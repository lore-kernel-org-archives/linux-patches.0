Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0501C0DE7;
	Tue, 27 Aug 2024 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769798; cv=none; b=PorlnZb1plkeBHqk1eHDmTUXlitxoIBQKjCwFmg/WegKW55/BQ1doj8pDpJDOYOMOIuRM1XXLOOgxnm1UH44UiVmgro+g/nz0XUzdW4GPtcC2MYltR0j31tzHyqgDErYa0pteoqKhLtPwz02+cK3764/eAZwZFYHCZHn77SaKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769798; c=relaxed/simple;
	bh=j2Q6VLgdKtXfR1Mm3u3v3g4Ntp0TEd907o50FrldRoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDKtF4UCKQai1LMHVG6NFvQXd4iLXMRYkP6n2DIY0E7S+iKHKtIAdeedFTqt7mWvTjJC9ht/eJBjPMX5B+RhhMlb3B25qYKBb9CVR4A0pUdIv97H9Uol6zlH2hgrx4QeFfO5Ilh920F/9/QcAe1W5g7Oh+i8a0/ebRBentkso6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJdmlUJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJdmlUJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE0BC6104E;
	Tue, 27 Aug 2024 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769797;
	bh=j2Q6VLgdKtXfR1Mm3u3v3g4Ntp0TEd907o50FrldRoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJdmlUJqbw7hOypI5sMhyYWf+vDyUEqM/eOKMDLfJFglk/HaH7APvI0RfoKYQXW7v
	 Jh3ibqWxTQ4rD7Re06N96rDiwVFXcAfkux9H6f7NG81ZyA9nmaLD8Nl7sYk6xLpIMs
	 dwkTC3VinJ9Kajp059ys+oQ8ydF9aOHPfUydPuc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 038/341] selinux: add the processing of the failure of avc_add_xperms_decision()
Date: Tue, 27 Aug 2024 16:34:29 +0200
Message-ID: <20240827143844.862917138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 6dd1e4c045afa6a4ba5d46f044c83bd357c593c2 upstream.

When avc_add_xperms_decision() fails, the information recorded by the new
avc node is incomplete. In this case, the new avc node should be released
instead of replacing the old avc node.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -907,7 +907,11 @@ static int avc_update_node(u32 event, u3
 		node->ae.avd.auditdeny &= ~perms;
 		break;
 	case AVC_CALLBACK_ADD_XPERMS:
-		avc_add_xperms_decision(node, xpd);
+		rc = avc_add_xperms_decision(node, xpd);
+		if (rc) {
+			avc_node_kill(node);
+			goto out_unlock;
+		}
 		break;
 	}
 	avc_node_replace(node, orig);


