Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577452772A;
	Thu, 15 Aug 2024 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732308; cv=none; b=STUt33oUD+p+NkcYS1FX2a9eLUDTP06j+L77WR3KgEU4ASqLIyCyKYolmBvKK5RydpqK05YJfuvvT0a+JYJ8F49gP2qMqHq9PsgAnToIyWssqu/ZQbssSir2bvl+pAaZ9bxzF/55hzRrt1ZSp6v7eDI8GJH0PVkGGtg+p9UH8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732308; c=relaxed/simple;
	bh=XtMvZ3rGermZSeBbgdvbZTLwnFRC9SfQR+bVjZnnbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMSYxsOuojAE3I7k4ESV+oYHAKpf6Cl9+1DOEjKLK0SENq0IKj6HM0KSewax/f9bNQFgfyeDlHU1c6JWxQZw3uczUZOQPk3i/qCRNiwPBh/HMnhuSRJezhYiPMdbhwn8NyUjfQBDfyqUCYTUWl1kVWrcfMwJ+MtWz+r8WdLEAfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrFn9QgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrFn9QgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD6C32786;
	Thu, 15 Aug 2024 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732308;
	bh=XtMvZ3rGermZSeBbgdvbZTLwnFRC9SfQR+bVjZnnbxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrFn9QgUmmitZHVyazc1eQ4CUBAiN6mVV/9PcnNFOlswf8jbIObrybVn8Kev0FPtY
	 cG4spUU6YI6Bp5l+cVpQQkdxsVyvrYcxbAZ+8fRPXStWD0+9YzsQTAMqLTPTvPXdTn
	 M9K+mMkFGLUIcSWL7SNP0Nc6hh5rMLEcG/bkeWtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.10 139/352] apparmor: use kvfree_sensitive to free data->data
Date: Thu, 15 Aug 2024 15:23:25 +0200
Message-ID: <20240815131924.631124712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
@@ -915,6 +915,7 @@ static struct aa_profile *unpack_profile
 
 			if (rhashtable_insert_fast(profile->data, &data->head,
 						   profile->data->p)) {
+				kvfree_sensitive(data->data, data->size);
 				kfree_sensitive(data->key);
 				kfree_sensitive(data);
 				info = "failed to insert data to table";


