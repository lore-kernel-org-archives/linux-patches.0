Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D18E473C9C;
	Tue, 21 Jul 2026 21:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667875; cv=none; b=br/qlnAZWzCJ4kQ07lqM8qxiRaH+3bY7J9yIxY5DfSE7il+2/A16Fjww5Wbd6kW901rPXgi2ijtdU5Nsp+SM0Zn09lYifOGyldyVJKjY3sQP16WwYir9CPBXkdtjM3rkMGgssi4oYj8YLGZ+l5TsdZ+Tc+u6F31v0N7zmrsqPtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667875; c=relaxed/simple;
	bh=6AwbrpY1MjEOSPPyCvbI6M0/me0rjjyhLpX8ytOorVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/NfUzXo/YHQj0T8H+/Vk0tDgzn9HAqxGZWZs5TaMzJE+DA7Fqxi1oSZVGWUn6/G357G/4PnTC9Ah4RpwNlpaaVzxmt6d1rMlLHLipGIs0lRBQkQWontDnOkc2Yi2qkhmTPd6bpEVfxKzikpf56WFibGW4eZaj+K1Ti7dIKFPN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEJnb4M0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEJnb4M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E649B1F00A3A;
	Tue, 21 Jul 2026 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667872;
	bh=gc2Kh+kup8JNtuvUocVsEF/9zp+GF4hjgUsAWhmV3GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEJnb4M0vqirSfrReeZYeNndbyUtBW8a+cT6vzBH7Qu5ssuoYp0Jet5Sp6glK/+Ap
	 K3Quszc3gD1ChZp3U5FCSf3xABoWC2xvK8qewD3sYvNY8zQ5Kda6exOuod2hFC1SGU
	 6ybrw+hM0PbnobQIN/3/6rL0D3OfU21tk9EswwTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1224/1266] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Tue, 21 Jul 2026 17:27:41 +0200
Message-ID: <20260721152509.194669559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 9cff680e47632b7723cb19f9c5e63669063c3417 ]

VDO() second parameter is VDM type (bit 15): 1 for SVDM, 0 for UVDM.
Using 'vdo ? 2 : 1' corrupts SVID low bit when vdo is non-NULL
(2 << 15 = BIT(16)). Enter Mode is always SVDM, hardcode to 1.

Fixes: 8face9aa57c8 ("usb: typec: Add parameter for the VDO to typec_altmode_enter()")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260604105059.18750-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2237,7 +2237,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0);


