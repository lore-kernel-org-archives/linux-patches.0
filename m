Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C454C1A619E;
	Tue, 30 Jul 2024 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357466; cv=none; b=F5gKoHXECLsye3HGUBG5AMIRb/zXOjkouWlCHxl8Wcj0Ng9DYMXhD4nXnSdHtNyzOxMuHLJ0ZNaISHksAf6czhsIvn4wQ8qZ+U/rAF5N60r/dZvjxEbAAp2uzhoy6RYrhTnEdrjlSlrIJz34+Jh/d5z94O080MkvHQal4V87WcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357466; c=relaxed/simple;
	bh=ldDOgJY/7chqjIxSfHDmrnFEzbR3PkuHOW72bWytBDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I82c9XlYQwg/73sIneGwuG6F70i1vA5qxJMdX5gNulF3eVighputXceOjYoWMrGzsInIeBhSA2p9jP5dR6bOljLwORtlVxBWasq2fIH2bpvxCUHPkul9Hi+zkHQZfiZOnkb+DV8oOiTBaJ5vPLhFjX3tdqw7+ftT50CYsNSb1w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTSUGsG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTSUGsG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071BAC4AF0C;
	Tue, 30 Jul 2024 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357466;
	bh=ldDOgJY/7chqjIxSfHDmrnFEzbR3PkuHOW72bWytBDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTSUGsG9W/GSd0O+CUkjZYLhpm06Ao4iLFwIIuF6sCLGE45jvjHBGlMzyY5C/RPvN
	 cFA1cVUI91K7/8TXLE943j9jE7gfRwUzHfSE0PbHR3WVgXJu8jgOBdaGh9JramaOKt
	 I98BF3tG5fUQKDKfFDoN4ZgbuTUNLlj6Nv6RTqcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.1 295/440] apparmor: use kvfree_sensitive to free data->data
Date: Tue, 30 Jul 2024 17:48:48 +0200
Message-ID: <20240730151627.352319869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -187,7 +187,7 @@ static void aa_free_data(void *ptr, void
 {
 	struct aa_data *data = ptr;
 
-	kfree_sensitive(data->data);
+	kvfree_sensitive(data->data, data->size);
 	kfree_sensitive(data->key);
 	kfree_sensitive(data);
 }
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -898,6 +898,7 @@ static struct aa_profile *unpack_profile
 
 			if (rhashtable_insert_fast(profile->data, &data->head,
 						   profile->data->p)) {
+				kvfree_sensitive(data->data, data->size);
 				kfree_sensitive(data->key);
 				kfree_sensitive(data);
 				info = "failed to insert data to table";


