Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0D85336E;
	Tue,  3 Dec 2024 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240345; cv=none; b=MA97asZ1WVNvef+v04ES6M7RS1uVw+1YeZoU/k/MIoNFHdjHwMgQPOyarThPMe8yCmNmsMdWsovmKZ0RF9WdpJOFbUH9SMf8horiBNjUcmf2rj4Lhpn71ZxwfwzJrFPEr3ocH/Wqm+JBToknR5BKoEMI9cUPeE2s6zrpfKTkG8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240345; c=relaxed/simple;
	bh=uqD6GzilJgcRAeeK4XKDZumvZXx1cCECcPxkbEiqObc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6vGe9QwqYWB1kFoL5ikzNuhWSNPHwMJF8wJHgisZAztfRyRSL7ujwnC0z7KUarlcgpzFbHaY33txkAD94nMrSbC3zcwLxWRM/gA71sr7/H57pMDrTUcHQsxaoXww1cs1VPunQYi9nmuEUWZMszwrrUJl1D4qA/0YqmGus+x3c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eULWTKao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eULWTKao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CD0C4CECF;
	Tue,  3 Dec 2024 15:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240344;
	bh=uqD6GzilJgcRAeeK4XKDZumvZXx1cCECcPxkbEiqObc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eULWTKaoRTmcyuvFvETqc7WsbsR57pwyxwdsG+fQPdCwfNkj5Z1Soek8lb0GWt1j5
	 pLzopI8vxyUb+A6gMNNZODxa8mpY89bSW+FlhFyLKoh/Z/+e0Va07PlEA4CFHHLfou
	 6jjAu450ap/W6apDStvGN2yBMrBFN+LyCLTkp5YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/826] sched/cpufreq: Ensure sd is rebuilt for EAS check
Date: Tue,  3 Dec 2024 15:36:33 +0100
Message-ID: <20241203144746.047399538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 70d8b6485b0bcd135b6699fc4252d2272818d1fb ]

Ensure sugov_eas_rebuild_sd() is always called when sugov_init()
succeeds. The out goto initialized sugov without forcing the rebuild.

Previously the missing call to sugov_eas_rebuild_sd() could lead to EAS
not being enabled on boot when it should have been, because it requires
all policies to be controlled by schedutil while they might not have
been initialized yet.

Fixes: e7a1b32e43b1 ("cpufreq: Rebuild sched-domains when removing cpufreq driver")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/35e572d9-1152-406a-9e34-2525f7548af9@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index c6ba15388ea70..28c77904ea749 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -783,9 +783,8 @@ static int sugov_init(struct cpufreq_policy *policy)
 	if (ret)
 		goto fail;
 
-	sugov_eas_rebuild_sd();
-
 out:
+	sugov_eas_rebuild_sd();
 	mutex_unlock(&global_tunables_lock);
 	return 0;
 
-- 
2.43.0



