Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D02C032C;
	Thu, 12 Mar 2026 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345946; cv=none; b=Ctc2rBJI6+p2tpmEp4s2SrZ0QOE+rbDG9vE4139xnOCSgGlvo8xpURWlwquXpKyJeQdlsZkqQdH+TNxC1J1UYf1bNE7ogoDXWfwa6SCOM2Du9W+p79lmsS6TPEhgX32Pyb/93xVP54tXS4gD6w/22MTujgIIVbFce09aeEsp6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345946; c=relaxed/simple;
	bh=N1KgQp9mVkdDN1dviDZQczc16CPZMO3tiP/zGK1ByLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu1P0BhGF/dITVpjMvzSi2IjKt7dK+ZJgl7McMWsA6jIPQKLiSUqqVUcEFISOzJkKX5zjCXG6qqztowUjAwRIoRwkpCbT5QdP9jrUw/ZSxxAp/0D9Wj/rvtWGfeewp4mqBU78KUMq6r/wr5UdDyMEU0Zgb8SzrHE7d4Bef/rfO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaojzgiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaojzgiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88489C4CEF7;
	Thu, 12 Mar 2026 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345946;
	bh=N1KgQp9mVkdDN1dviDZQczc16CPZMO3tiP/zGK1ByLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaojzgiPNTbcPZXm0X3zooPklMJKNF5gHmoa0Khi5/5gzWYCzkoxR+9HbAPnEUptT
	 EEaN8ri6XbtsqzogXGqEquZXY1s0IzWlN4jYYwQ/z+HeiQk9labfP+mbpkWodVfW5+
	 /0C7pdHxuQUsI0gvNEUDTEl39gIIXL/EsyQbO20s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.18 09/13] apparmor: Fix double free of ns_name in aa_replace_profiles()
Date: Thu, 12 Mar 2026 21:03:50 +0100
Message-ID: <20260312200326.586390381@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

commit 5df0c44e8f5f619d3beb871207aded7c78414502 upstream.

if ns_name is NULL after
1071         error = aa_unpack(udata, &lh, &ns_name);

and if ent->ns_name contains an ns_name in
1089                 } else if (ent->ns_name) {

then ns_name is assigned the ent->ns_name
1095                         ns_name = ent->ns_name;

however ent->ns_name is freed at
1262                 aa_load_ent_free(ent);

and then again when freeing ns_name at
1270         kfree(ns_name);

Fix this by NULLing out ent->ns_name after it is transferred to ns_name

Fixes: 145a0ef21c8e9 ("apparmor: fix blob compression when ns is forced on a policy load
")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1149,6 +1149,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 				goto fail;
 			}
 			ns_name = ent->ns_name;
+			ent->ns_name = NULL;
 		} else
 			count++;
 	}


