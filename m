Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0404E73A1;
	Thu, 17 Sep 2026 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668112; cv=none; b=DNq/Q2lnniP1+HxlbdB2Bi7qVNqSrZHwW/ChNhH6kdp2vVl4cYs7UPvzO/DOSr3MGtxFgCkeIgEZ3SnspLDNJKDTF3N77CmkINA0aOQ3q4bhEFFB2Z8jHre6QTYsEqgpuvRfCOIVnjAlJxVbpbf1COzXGM8mnb5JY4eA2qLIfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668112; c=relaxed/simple;
	bh=YNpZ/oqwHixoAJjQpsSpp9I7Jao4iWkm5FSc+aa+j8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQY3tp84fJ+hm4H0sSjQ09gwWtK7ZSSnXkeIR22nzk25nIkv6WDgmwxow7Ym4V82gE7HxkVpSKPhL4q5D6pwO666js5BYGT7lY/asI5ZoqdZHRfV9Dr6BY0js6lgVcRiMc1p7MuRdzxdqAp82eGn467d+vD8JTL5l/Y1peo3gpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWkWx8qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWkWx8qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D4B1F00893;
	Thu, 17 Sep 2026 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668110;
	bh=zRMYMiR/Q9rLUbSao6hmBNEesbhwTSs9zCUMBNzaxk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWkWx8qcR4CQ6rFzBBe3Dxea/W2av0IviCeju0B20e38d7UZ1SxAzubfICabGHc0E
	 jZmxoMD+TTjHQuiG1dpbsBvVX+CE0+g/+v8+fdxUXQz3ii1CxLLg5jUB2Da0Zzazg5
	 oWlHocUrrIkGWUN3wfXGiqaXGz6jvZBElS/UhrpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0316/1102] HID: hidpp: fix potential UAF in hidpp_connect_event()
Date: Thu, 17 Sep 2026 16:04:19 +0100
Message-ID: <20260917151547.557099510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 6df6b1f2c49678211f65647c300bc51dda02893b ]

If input_register_device() fails, we call input_free_device(), but keep
stale pointer to the old device in hidpp->input, which could potentially
lead to UAF. Fix that by resetting it to NULL before returning from
hidpp_connect_event().

Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index c4ea7f2552561..676caeb1e21e6 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4308,6 +4308,7 @@ static void hidpp_connect_event(struct work_struct *work)
 
 	ret = input_register_device(input);
 	if (ret) {
+		hidpp->input = NULL;
 		input_free_device(input);
 		return;
 	}
-- 
2.53.0



