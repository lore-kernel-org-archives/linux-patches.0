Received: from mail.kent-dobias.com (mail.kent-dobias.com [71.19.144.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A515384
	for <patches@lists.linux.dev>; Sun, 10 Dec 2023 09:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kent-dobias.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kent-dobias.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kent-dobias.com header.i=@kent-dobias.com header.b="Q2N97UWF"
Date: Sun, 10 Dec 2023 10:32:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=kent-dobias.com;
	s=dkim; t=1702200783;
	bh=LuzuMYo3uRoi3ktaBaZkb3pTcyev5Zpd2K1wlmDVDZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q2N97UWFESmkPAZ9g4HSQhlMItd89Vo9dqvNaH0xNGcWI3/h56oYO1NmO9F/rjy74
	 iC3LDP2VFaKpCCk9tjj+KvRWK/BBhC/BhUK1qjDGGhqWLw0MkMjYb42FnvDhJFoN93
	 YtIz1OiSDNbtrG612AslYbOI7qHUvzCaKpjrCfDc=
From: Jaron Kent-Dobias <jaron@kent-dobias.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 6.6 074/134] wifi: cfg80211: fix CQM for non-range use
Message-ID: <ZXWFyGnQjSO5ZKwl@mail.kent-dobias.com>
References: <20231205031535.163661217@linuxfoundation.org>
 <20231205031540.189275884@linuxfoundation.org>
 <87sf4belmm.fsf@turtle.gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87sf4belmm.fsf@turtle.gmx.de>


On Saturday, 9 December 2023 at 11:05 (+0100), Sven Joachim wrote:
>On 2023-12-05 12:15 +0900, Greg Kroah-Hartman wrote:
>
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.
>>
>> My prior race fix here broke CQM when ranges aren't used, as
>> the reporting worker now requires the cqm_config to be set in
>> the wdev, but isn't set when there's no range configured.
>>
>> Rather than continuing to special-case the range version, set
>> the cqm_config always and configure accordingly, also tracking
>> if range was used or not to be able to clear the configuration
>> appropriately with the same API, which was actually not right
>> if both were implemented by a driver for some reason, as is
>> the case with mac80211 (though there the implementations are
>> equivalent so it doesn't matter.)
>>
>> Also, the original multiple-RSSI commit lost checking for the
>> callback, so might have potentially crashed if a driver had
>> neither implementation, and userspace tried to use it despite
>> not being advertised as supported.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 4a4b8169501b ("cfg80211: Accept multiple RSSI thresholds for CQM")
>> Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  net/wireless/core.h    |    1
>>  net/wireless/nl80211.c |   50 ++++++++++++++++++++++++++++++-------------------
>>  2 files changed, 32 insertions(+), 19 deletions(-)
>>
>> --- a/net/wireless/core.h
>> +++ b/net/wireless/core.h
>> @@ -299,6 +299,7 @@ struct cfg80211_cqm_config {
>>  	u32 rssi_hyst;
>>  	s32 last_rssi_event_value;
>>  	enum nl80211_cqm_rssi_threshold_event last_rssi_event_type;
>> +	bool use_range_api;
>>  	int n_rssi_thresholds;
>>  	s32 rssi_thresholds[] __counted_by(n_rssi_thresholds);
>>  };
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -12824,10 +12824,6 @@ static int cfg80211_cqm_rssi_update(stru
>>  	int i, n, low_index;
>>  	int err;
>>
>> -	/* RSSI reporting disabled? */
>> -	if (!cqm_config)
>> -		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
>> -
>>  	/*
>>  	 * Obtain current RSSI value if possible, if not and no RSSI threshold
>>  	 * event has been received yet, we should receive an event after a
>> @@ -12902,18 +12898,6 @@ static int nl80211_set_cqm_rssi(struct g
>>  	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
>>  		return -EOPNOTSUPP;
>>
>> -	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
>> -		if (n_thresholds == 0 || thresholds[0] == 0) /* Disabling */
>> -			return rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
>> -
>> -		return rdev_set_cqm_rssi_config(rdev, dev,
>> -						thresholds[0], hysteresis);
>> -	}
>> -
>> -	if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> -				     NL80211_EXT_FEATURE_CQM_RSSI_LIST))
>> -		return -EOPNOTSUPP;
>> -
>>  	if (n_thresholds == 1 && thresholds[0] == 0) /* Disabling */
>>  		n_thresholds = 0;
>>
>> @@ -12921,6 +12905,20 @@ static int nl80211_set_cqm_rssi(struct g
>>  	old = rcu_dereference_protected(wdev->cqm_config,
>>  					lockdep_is_held(&wdev->mtx));
>>
>> +	/* if already disabled just succeed */
>> +	if (!n_thresholds && !old)
>> +		return 0;
>> +
>> +	if (n_thresholds > 1) {
>> +		if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> +					     NL80211_EXT_FEATURE_CQM_RSSI_LIST) ||
>> +		    !rdev->ops->set_cqm_rssi_range_config)
>> +			return -EOPNOTSUPP;
>> +	} else {
>> +		if (!rdev->ops->set_cqm_rssi_config)
>> +			return -EOPNOTSUPP;
>> +	}
>> +
>>  	if (n_thresholds) {
>>  		cqm_config = kzalloc(struct_size(cqm_config, rssi_thresholds,
>>  						 n_thresholds),
>> @@ -12935,13 +12933,26 @@ static int nl80211_set_cqm_rssi(struct g
>>  		memcpy(cqm_config->rssi_thresholds, thresholds,
>>  		       flex_array_size(cqm_config, rssi_thresholds,
>>  				       n_thresholds));
>> +		cqm_config->use_range_api = n_thresholds > 1 ||
>> +					    !rdev->ops->set_cqm_rssi_config;
>>
>>  		rcu_assign_pointer(wdev->cqm_config, cqm_config);
>> +
>> +		if (cqm_config->use_range_api)
>> +			err = cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
>> +		else
>> +			err = rdev_set_cqm_rssi_config(rdev, dev,
>> +						       thresholds[0],
>> +						       hysteresis);
>>  	} else {
>>  		RCU_INIT_POINTER(wdev->cqm_config, NULL);
>> +		/* if enabled as range also disable via range */
>> +		if (old->use_range_api)
>> +			err = rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
>> +		else
>> +			err = rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
>>  	}
>>
>> -	err = cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
>>  	if (err) {
>>  		rcu_assign_pointer(wdev->cqm_config, old);
>>  		kfree_rcu(cqm_config, rcu_head);
>> @@ -19131,10 +19142,11 @@ void cfg80211_cqm_rssi_notify_work(struc
>>  	wdev_lock(wdev);
>>  	cqm_config = rcu_dereference_protected(wdev->cqm_config,
>>  					       lockdep_is_held(&wdev->mtx));
>> -	if (!wdev->cqm_config)
>> +	if (!cqm_config)
>>  		goto unlock;
>>
>> -	cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
>> +	if (cqm_config->use_range_api)
>> +		cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
>>
>>  	rssi_level = cqm_config->last_rssi_event_value;
>>  	rssi_event = cqm_config->last_rssi_event_type;
>
>After upgrading to 6.6.5, I noticed that my laptop would hang on
>shutdown and bisected that problem to this patch.  Reverting it makes
>the problem go away.
>
>More specifically, NetworkManager and wpa_supplicant processes are hung.
>This can also be triggered by "systemctl stop NetworkManager.service"
>which does not complete and brings these two processes into a state of
>uninterruptible sleep.

I have a similar problem that I also traced to this commit. When I use 
6.6.5 with iwd and the proprietary broadcom-wl driver, iwd deadlocks 
when trying to associate with an access point, and eventually every 
process that tries to query network information (ip, systemd, etc) 
likewise deadlocks.

>I also tried 6.1 and mainline, and could reproduce the hang in 6.1.66
>but _not_ in 6.7-rc4, so maybe some patch from Linus' tree needs to be
>applied to the stable branches.

The problem goes away when I revert this commit on top of 6.6.5. I 
haven't tried Linus' tree or the older stable branches.

Best,
Jaron

