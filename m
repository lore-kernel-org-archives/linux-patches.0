Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAF53438AE;
	Sat, 30 May 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162160; cv=none; b=mTE0t/aKlTO3cJTC3Yy/2cXIAhwSpqnyoaephM2fVq8XmKOHtaS1b47MZCHv54d/sHRY0AZEibcBVQOl88DJxTboTSWRM/XpUtGtrfj/hwVTO9fWN9Lslc515G6Nj8VcnDBIZaL/jsRRde6Ib42TeamrnqjXGDEPis/C1f6mHBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162160; c=relaxed/simple;
	bh=wvMFbXi9PXO25bYS8hOTWIB0gRJhVgQUefWQUB+zho0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROVFUcoAbaDQAiTedI/aL6S0p1ktl+MfxMasqguA4tMSidgpgT8JCXTNP00SkhPDASvCotfPcB06OFFqsRxVKxz/gcZzBkLQqMNOXWGLe9dWbuwcKprcA2ukhSIkfeGmU+LMGEY1WOYJcTIL8XwLMd7fqg9INwwSKlTcieMhGT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOomWBLv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOomWBLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAAE1F00893;
	Sat, 30 May 2026 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162159;
	bh=bMbpMybywssTR+wcMgZI/VJTaZKkqjp0Z7+ICdYEKCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOomWBLveq1IRsl6JskuXNl9SpQYl4qw1S8vKia5+kGjK1t3TbIbx0PuO4PlLAtSG
	 WZHZGwxaPlYq6MvIJB8HJTadHzCrca1QGSamQvv2mR5lNpmTDFI/nYQR/DNIVWfbs4
	 Li3Ep+RcpeVDKOpzc6O7R65SjG1ElgDoUTPs9hLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	stable <stable@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 839/969] sysfs: dont remove existing directory on update failure
Date: Sat, 30 May 2026 18:06:03 +0200
Message-ID: <20260530160323.819827795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 237557b8a81ab948e8332f7c0058e758f081c0a3 upstream.

When sysfs_update_group() is called for a named group and create_files()
fails (e.g. -ENOMEM), internal_create_group() calls kernfs_remove(kn) on
the group directory.  In the update path, kn was obtained via
kernfs_find_and_get() and refers to a directory that already existed
before this call.  Removing it silently destroys a sysfs group that the
caller did not create.

Only remove the directory if we created it ourselves.  On update failure
the directory remains as it is left empty by remove_files() inside
create_files(), but can be repopulated by a retry.

Cc: Rajat Jain <rajatja@google.com>
Fixes: c855cf2759d2 ("sysfs: Fix internal_create_group() for named group updates")
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052003-uniquely-hastily-c093@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -147,7 +147,7 @@ static int internal_create_group(struct
 	kernfs_get(kn);
 	error = create_files(kn, kobj, uid, gid, grp, update);
 	if (error) {
-		if (grp->name)
+		if (grp->name && !update)
 			kernfs_remove(kn);
 	}
 	kernfs_put(kn);


