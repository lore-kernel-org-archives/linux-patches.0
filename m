Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BBA3F660B;
	Wed, 20 May 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299551; cv=none; b=IEuKxg+l9L4hFxLx2nLMwdFyMdnRqusQSkTcBzcRTlFA24McGEjNgvUSYE+cR/qQ3aVt03Vtrg15fD9AJlg+DrlnNpxjhSeO5qcgyU82StbWLuIwHog9E5B2FvWnli/JajV5qge+o4tHYr/VKjmN13xgpyhx42L09vH0OR/7Qqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299551; c=relaxed/simple;
	bh=lUaAMRJw9gWqxh7drORQqK4Z3qCQm0ef0WgaCgh7J4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsLZpNK6Iy6IshA0Ll6s9lboJxCcj0DSuaHxZGzdV53LTyvYGVjdEdXSwmsSLv7gA/8lW2+q2sk2IzBNhwZCZH/xfPwLG+ycssojrzA4BY4p6AMqBBmLhee7vd899CX44zbG2wuRYwToTEWdt5gnqmYoAiVxjOobDvGSkxNlWP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9wM0xit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9wM0xit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075D11F000E9;
	Wed, 20 May 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299550;
	bh=JX+i9WKY5oATkhPrCQF1k6PQ5yuADJjFv7qrKhlPQ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9wM0xitANWbuNe/N1/La1yY/4zb5Yj+9l/Js9ixLcwPqW49DPOWvhiVG0H0rVCMl
	 L22scWbNxKTJq4OE26oPMLVaCuH/4+fScn6IL3vSXtQa0Y/LoN5eiQAToklXl3p3bh
	 MwVT9wLaBOXx6nD/e1BDqa9WKXYWOBG11Gro4cic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 815/957] net: psp: check for device unregister when creating assoc
Date: Wed, 20 May 2026 18:21:38 +0200
Message-ID: <20260520162152.241420479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b89769f936a8fa9e66de72ddc1b71a9745a488e6 ]

psp_assoc_device_get_locked() obtains a psp_dev reference via
psp_dev_get_for_sock() (which uses psp_dev_tryget() under RCU);
it then acquires psd->lock and drops the reference. Before
the lock is taken, psp_dev_unregister() can run to completion:
take psd->lock, clear out state, unlock, drop the registration
reference.

The expectation is that the lock prevents device unregistration,
but much like with netdevs special care has to be taken when
"upgrading" a reference to a locked device. Add the missing
check if device is still alive. psp_dev_is_registered() exists
already but had no callers, which makes me wonder if I either
forgot to add this or lost the check during refactoring...

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260427190606.366101-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psp/psp_nl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp_nl.c b/net/psp/psp_nl.c
index 8aaca62744c3c..3f63ffbc5c575 100644
--- a/net/psp/psp_nl.c
+++ b/net/psp/psp_nl.c
@@ -303,8 +303,13 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 
 	psd = psp_dev_get_for_sock(socket->sk);
 	if (psd) {
-		err = psp_dev_check_access(psd, genl_info_net(info));
-		if (err) {
+		/* Extra care needed here, psp_dev_get_for_sock() only gives
+		 * us access to struct psp_dev's memory, which is quite weak.
+		 */
+		mutex_lock(&psd->lock);
+		if (!psp_dev_is_registered(psd) ||
+		    psp_dev_check_access(psd, genl_info_net(info))) {
+			mutex_unlock(&psd->lock);
 			psp_dev_put(psd);
 			psd = NULL;
 		}
@@ -317,7 +322,6 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 
 	id = info->attrs[PSP_A_ASSOC_DEV_ID];
 	if (psd) {
-		mutex_lock(&psd->lock);
 		if (id && psd->id != nla_get_u32(id)) {
 			mutex_unlock(&psd->lock);
 			NL_SET_ERR_MSG_ATTR(info->extack, id,
-- 
2.53.0



