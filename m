Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEC517D8BB;
	Tue, 30 Jul 2024 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358727; cv=none; b=tfqqrtCU5Uv8ggcVTMZ18rDPoLxC5qHKU2A1vVVbTQ0SjGw0gzQif+2YrshFn7zNWDBziuwof1w/PY3UgG6KPcAJDh9VuYwcQA6FnQXHtepS17u4Lxo/H2Madv+FcrWmVimDHhljrLey0GfcxOyuLfAz6gvA/qQerdbUGA4sf4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358727; c=relaxed/simple;
	bh=n2Xi1QV0deJyNFjxJy+dUuQX7P9pMgvse5M530eYwt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkLkmTnwAF+zvlhaxY4Ky8ebk7p80HV2Q7E8Q4nV4TPoMdTqxsvlsfeX+Rj++lEBC5d49CErk2Kn+XkQ5s5kGS9N2bpSPKBINS2C1kyY3wI/4QdxG/dNtFBxGOpdhRyWqc4F1W0doso8dnJpffBNW//MF5NV94m7a+T1vtTIdWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+v1rAsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+v1rAsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19392C32782;
	Tue, 30 Jul 2024 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358727;
	bh=n2Xi1QV0deJyNFjxJy+dUuQX7P9pMgvse5M530eYwt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+v1rAsXS0sK9CnHXfowWDbHoQVQrP1DF8+grKw4zbe4Nq3lVMwL1LZsJPWEh2KX0
	 l006dC+1biWwAcbwst1txLbo9nt5heT8d5sCKrQkY/eWBjYxudw9uMwwrOIrso9M2v
	 ff/oRDAdKi0OK/VmymvXsPWUOk2bxljOFFKx6R0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.6 389/568] apparmor: use kvfree_sensitive to free data->data
Date: Tue, 30 Jul 2024 17:48:16 +0200
Message-ID: <20240730151655.068268895@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -188,7 +188,7 @@ static void aa_free_data(void *ptr, void
 {
 	struct aa_data *data = ptr;
 
-	kfree_sensitive(data->data);
+	kvfree_sensitive(data->data, data->size);
 	kfree_sensitive(data->key);
 	kfree_sensitive(data);
 }
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1081,6 +1081,7 @@ static struct aa_profile *unpack_profile
 
 			if (rhashtable_insert_fast(profile->data, &data->head,
 						   profile->data->p)) {
+				kvfree_sensitive(data->data, data->size);
 				kfree_sensitive(data->key);
 				kfree_sensitive(data);
 				info = "failed to insert data to table";


