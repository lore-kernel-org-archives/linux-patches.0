Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784751DFE10;
	Wed,  6 Nov 2024 13:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899044; cv=none; b=SAbCWrUuSQom2YGbzS8Si44uFHfyyyhgyXGGEnX4pif8IyfZ44bzapNgHBcqVl5VXKI4mB0mnrek9aKDMc2jyZUpJGtG7tq7KA96WFncl5HnW8gf7Mud6B+2w8/J6bvVST8nB0enHqp05PoDeKeUCKaLNVqbi7156WapjMXdopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899044; c=relaxed/simple;
	bh=sH2LbOe9g0Wp3cdzdoF6EpRPbjVWIMprlZO2fdLg3cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX0dGMBSplwSCqV8BOEyVgqc63gGH7SvimVNXIqaX4w+yd6J6BS7e1z8GXZOKUYn3aKea5W2I9MbMYBgs8JdjxemmIsJeYzT2b03FLGzMFZSWfV9tnzopcwcwvcRDO8gst0NvGXf147w2fNO/qjYCofDN4sSMso0ZZnKxRVZahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFfZa4D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFfZa4D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22FFC4CECD;
	Wed,  6 Nov 2024 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899044;
	bh=sH2LbOe9g0Wp3cdzdoF6EpRPbjVWIMprlZO2fdLg3cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFfZa4D0AqEMz+NvZXWxaXX98Xk1GSbLIvF/wQCggSNdBzY5OiSyRgCrvZlNQqPyB
	 euvh/nqCqzSvi/3R6eTZJLEf1TFICG2lZjgUSfSK2vtjxaSBLFYprLsY2U5gNrDueZ
	 xQ42a42jPlfDqF/v5OQ0Kl6bXFDIB4817ozaRTKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc39f136925517aed571@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Antony Antony <antony.antony@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 425/462] xfrm: validate new SAs prefixlen using SA family when sel.family is unset
Date: Wed,  6 Nov 2024 13:05:18 +0100
Message-ID: <20241106120342.011211730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 3f0ab59e6537c6a8f9e1b355b48f9c05a76e8563 ]

This expands the validation introduced in commit 07bf7908950a ("xfrm:
Validate address prefix lengths in the xfrm selector.")

syzbot created an SA with
    usersa.sel.family = AF_UNSPEC
    usersa.sel.prefixlen_s = 128
    usersa.family = AF_INET

Because of the AF_UNSPEC selector, verify_newsa_info doesn't put
limits on prefixlen_{s,d}. But then copy_from_user_state sets
x->sel.family to usersa.family (AF_INET). Do the same conversion in
verify_newsa_info before validating prefixlen_{s,d}, since that's how
prefixlen is going to be used later on.

Reported-by: syzbot+cc39f136925517aed571@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f76033d1898a5..d9a32b13032a7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -149,6 +149,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 			     struct nlattr **attrs)
 {
 	int err;
+	u16 family = p->sel.family;
 
 	err = -EINVAL;
 	switch (p->family) {
@@ -167,7 +168,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	switch (p->sel.family) {
+	if (!family && !(p->flags & XFRM_STATE_AF_UNSPEC))
+		family = p->family;
+
+	switch (family) {
 	case AF_UNSPEC:
 		break;
 
-- 
2.43.0



