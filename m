Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BB91A76AE;
	Tue, 30 Jul 2024 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360058; cv=none; b=PjDUqQsaeE5ozLADhjY0j2v9o+BGAo33hwRCYGrabAbXjJwhQNJo4gx+CuJ7jli2yROeSp30vDbBYEnKfPN1k3m2VyH+eX+J+QQ3un/9BBi1nD8OvaOhC0+3wtTtcKI71qPj5Cmlu2N3VsqU2KqBQ7PmSeQcGKq/a58VO8s6iL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360058; c=relaxed/simple;
	bh=roHS7vVCSGDVoaXpJOCyL3opiCvKndp3VY8gWNLD+fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPMlRQFFCLSnMngZHwhjwUqLDg1ZNsB5FmVcogFe502tYWZwvefoeo5En1licQ70VhEsyoW8UkW1+HbzwNzf9k2KgayYVxv9bwiNUq1vZN3G3j0YBQ1+8qGEJHOX6KAOEuW/nUrj+DImqcfiXzYSInYPMTcKQNEcZTttNYNkHps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BCi14mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BCi14mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B70C32782;
	Tue, 30 Jul 2024 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360057;
	bh=roHS7vVCSGDVoaXpJOCyL3opiCvKndp3VY8gWNLD+fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BCi14mr0sQaDOaxKOaPY8Zj+cf5QZrH0uPPdktSw6++oz/Fo6tt3yrPy2LMNdEKj
	 FV2UkbfGkm+XJ9B3TU9BhbRV3lt/aflgdf9TXPWBE1zG+pNNw5xHvXpk7uuP+KqGmb
	 xur9mIGeesJ1CYSAV7kuMtaGdxNbW+g3iZ1OOf5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.10 583/809] apparmor: use kvfree_sensitive to free data->data
Date: Tue, 30 Jul 2024 17:47:39 +0200
Message-ID: <20240730151747.856146111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 2bc73505a5cd2a18a7a542022722f136c19e3b87 upstream.

Inside unpack_profile() data->data is allocated using kvmemdup() so it
should be freed with the corresponding kvfree_sensitive().

Also add missing data->data release for rhashtable insertion failure path
in unpack_profile().

Found by Linux Verification Center (linuxtesting.org).

Fixes: e025be0f26d5 ("apparmor: support querying extended trusted helper extra data")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c        |    2 +-
 security/apparmor/policy_unpack.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -225,7 +225,7 @@ static void aa_free_data(void *ptr, void
 {
 	struct aa_data *data = ptr;
 
-	kfree_sensitive(data->data);
+	kvfree_sensitive(data->data, data->size);
 	kfree_sensitive(data->key);
 	kfree_sensitive(data);
 }
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1071,6 +1071,7 @@ static struct aa_profile *unpack_profile
 
 			if (rhashtable_insert_fast(profile->data, &data->head,
 						   profile->data->p)) {
+				kvfree_sensitive(data->data, data->size);
 				kfree_sensitive(data->key);
 				kfree_sensitive(data);
 				info = "failed to insert data to table";


