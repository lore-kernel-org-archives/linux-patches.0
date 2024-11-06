Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733791EE028;
	Wed,  6 Nov 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896739; cv=none; b=COpfuZWWaj8MG80mPOEeIr/eDLoOz/YpjnVhh5Ufl7Ok6PrDCE9eORLzMLE1BtBjQpbafEq3UzxIyBydCf+ALLp/QnVL4t1FCQ+r855nJfA9wTaXxInNORb25/kUlsuAqLFGBHSZ/jZWT6ocsXICt5RZw9ohfE8FhANZeAocww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896739; c=relaxed/simple;
	bh=UfpO5n+vhHDOcy/txj/9mLYWfC6iAkecik9fDfQNQjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyXJ4+hHd0y6HnQdMEwC8PLb0IhiXh8sKTpWGX/K7x02Y2/eHIzfl0Hz2stOgZQiqM7fBZukxVZXcdGY0vXyR0VzCP2q00Sr4Nadq5vpfFDTyZzvOFM4r3797baMxyKQ/eR9tqgObtpFc+XuH76rjot2i14ukDAgzoya0IXNAAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OIqc4Le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OIqc4Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF04C4CED4;
	Wed,  6 Nov 2024 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896739;
	bh=UfpO5n+vhHDOcy/txj/9mLYWfC6iAkecik9fDfQNQjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OIqc4Le+Ee9r01lHGw79Z041MnX/jbMbo4al1rpfYz5SwoCpqVLcoPuD6pr7Qw/Y
	 kCZBy546B3cHz5oyzmxLj9M+U+qt9cAEE69cfhQK/JFe02g55WStQtwWGL2iepzmni
	 bpDBlsN26NXGnzEZsORPi5eou5vED0pX4Cm1C43E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc39f136925517aed571@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Antony Antony <antony.antony@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/110] xfrm: validate new SAs prefixlen using SA family when sel.family is unset
Date: Wed,  6 Nov 2024 13:04:22 +0100
Message-ID: <20241106120304.748388851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 070946d093817..e28e49499713f 100644
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



