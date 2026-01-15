Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5846E396B8F;
	Thu, 15 Jan 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496083; cv=none; b=bWT+AyxVu+Vi3yHFEEVqovyw00dUdjsa0+BC37N1HU6sFip1IVJwBD/rVxXwiBvqaHxa17ylK/ek9aNlUmHVO+6xfTtwoudvKoNfzRJlr2Wpyr/uT9kBzpabKmqoBSc+3O40GFhQEAQPHCkV6qQdEL8pAzN6/WD3rrzn51zYBFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496083; c=relaxed/simple;
	bh=llHWu19rQZs9haT6L0+CvAKjNAzxpAD6TclxcbfUKPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koguUfSQzBP4kNZCwswRLF4njPsAETOnVzemTC42i+YMSLKVv64IM+AYcmKEU1p+vX26B1MbiLAbEAKrstt7Bs9tJehvFi6NcLEGbKcgve6n2wqRBBzoxp3hhQgyn7jnbviKK3zzk4bi4gFqzwXTJOSACiugB1K2+QbwyBOhaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fu8t7AbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fu8t7AbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB96C116D0;
	Thu, 15 Jan 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496083;
	bh=llHWu19rQZs9haT6L0+CvAKjNAzxpAD6TclxcbfUKPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fu8t7AbGtrlG5LgPMYGV3eOVHDASb4tnJ1WwLIRaIUcEdCiH1MTPRX4atLUt909cQ
	 wUCcVSO9j3yBQUz/oqG0gY/7CoZffUqpDp2LLvn8GgDAYXBF5PykQvBDCBbsMOBgVt
	 WgokA1sniz/UTs3/b3of5Zs5URcyF/H3G/e2GzyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Subject: [PATCH 6.18 038/181] wifi: mac80211: restore non-chanctx injection behaviour
Date: Thu, 15 Jan 2026 17:46:15 +0100
Message-ID: <20260115164203.704299269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d594cc6f2c588810888df70c83a9654b6bc7942d upstream.

During the transition to use channel contexts throughout, the
ability to do injection while in monitor mode concurrent with
another interface was lost, since the (virtual) monitor won't
have a chanctx assigned in this scenario.

It's harder to fix drivers that actually transitioned to using
channel contexts themselves, such as mt76, but it's easy to do
those that are (still) just using the emulation. Do that.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218763
Reported-and-tested-by: Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Link: https://patch.msgid.link/20251216105242.18366-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2395,6 +2395,8 @@ netdev_tx_t ieee80211_monitor_start_xmit
 
 	if (chanctx_conf)
 		chandef = &chanctx_conf->def;
+	else if (local->emulate_chanctx)
+		chandef = &local->hw.conf.chandef;
 	else
 		goto fail_rcu;
 


