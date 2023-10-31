Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653692135A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JywdezjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD6C433C8;
	Tue, 31 Oct 2023 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774486;
	bh=AJbpoAc2YK3B73Qouj4sgpdZLjYAwEXhyytqXrHpGEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JywdezjSYfWwJmCpcORRs3eEIjh9LFsW8EODmz5Wx4KT7lmixb0h4wk05B7wVtuge
	 kG+m/xGldEP4NC4ltgg0vlXXhzn2qJSnmNlMTqbbZObC+R82Hyx2cH3cJKsCnJ9mNY
	 c7ZnTYSO63x0/VHHJYs+Q67tUj0lahu+ZGsH14qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Yikebaer Aizezi <yikebaer61@gmail.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 028/112] mm/mempolicy: fix set_mempolicy_home_node() previous VMA pointer
Date: Tue, 31 Oct 2023 18:00:29 +0100
Message-ID: <20231031165902.206790686@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 51f625377561e5b167da2db5aafb7ee268f691c5 upstream.

The two users of mbind_range() are expecting that mbind_range() will
update the pointer to the previous VMA, or return an error.  However,
set_mempolicy_home_node() does not call mbind_range() if there is no VMA
policy.  The fix is to update the pointer to the previous VMA prior to
continuing iterating the VMAs when there is no policy.

Users may experience a WARN_ON() during VMA policy updates when updating
a range of VMAs on the home node.

Link: https://lkml.kernel.org/r/20230928172432.2246534-1-Liam.Howlett@oracle.com
Link: https://lore.kernel.org/linux-mm/CALcu4rbT+fMVNaO_F2izaCT+e7jzcAciFkOvk21HGJsmLcUuwQ@mail.gmail.com/
Fixes: f4e9e0e69468 ("mm/mempolicy: fix use-after-free of VMA iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CALcu4rbT+fMVNaO_F2izaCT+e7jzcAciFkOvk21HGJsmLcUuwQ@mail.gmail.com/
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1543,8 +1543,10 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		 * the home node for vmas we already updated before.
 		 */
 		old = vma_policy(vma);
-		if (!old)
+		if (!old) {
+			prev = vma;
 			continue;
+		}
 		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
 			err = -EOPNOTSUPP;
 			break;


