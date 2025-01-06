Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018C51494C3;
	Mon,  6 Jan 2025 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177310; cv=none; b=WCESs4mhhLf5DtoX8R6QK7wAjPUfLvfxiLl7mirVTHUfVVXkKdrhDKwsUZEt2V9HqH7XdhZD5ECB3jFRDB0fYph2E1TsQ9UuVwnbXIikQ1w0DMePV7RnZ54mO36bhFLwv8IinSQsEc39y7M3upmQc9aD+viOHQX9rwelhRUpEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177310; c=relaxed/simple;
	bh=zylF1bQj6a38ekzc4x3ZxaRzhKvE4gBf/UuhP7YtTzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bL6nSyMwWQx0ca5GDK/yu7tgOJlXdYtWPIetPk+1Id9dnoS7QxIhYOa64CjVnPJ0vJULMbNkND1hJCJVQhWja49i0W8WhgDsaSYAv0MhpfFsV4JEuJGyk2yvZowZb01aPH5AMpQYChd71vVMMN4vV/Au/BX515ZthdZz8xw3dYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8EkqFEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8EkqFEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2755DC4CED2;
	Mon,  6 Jan 2025 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177308;
	bh=zylF1bQj6a38ekzc4x3ZxaRzhKvE4gBf/UuhP7YtTzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8EkqFEUbuE+SbKSSHVyFScivwTZb2iwPXk1sa8ZVyviBGX5yVsPQ4RHEFvYjA+0r
	 /tuIZze+9xajIOnuRlN/Fek+fCkLXRNIjM6Aed7ILw3dNKB+PabLZwChLfo3JFnPMf
	 kydKJd67llpit/Yc88Ca9XAEOQ6ARQWe/Jm90aAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dario=20Wei=C3=9Fer?= <dario@cure53.de>,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/222] ceph: give up on paths longer than PATH_MAX
Date: Mon,  6 Jan 2025 16:15:23 +0100
Message-ID: <20250106151155.114262356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 550f7ca98ee028a606aa75705a7e77b1bd11720f ]

If the full path to be built by ceph_mdsc_build_path() happens to be
longer than PATH_MAX, then this function will enter an endless (retry)
loop, effectively blocking the whole task.  Most of the machine
becomes unusable, making this a very simple and effective DoS
vulnerability.

I cannot imagine why this retry was ever implemented, but it seems
rather useless and harmful to me.  Let's remove it and fail with
ENAMETOOLONG instead.

Cc: stable@vger.kernel.org
Reported-by: Dario Weißer <dario@cure53.de>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 56609b80880c..5ee38dd2c9b9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2745,12 +2745,11 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn_client(cl, "did not end path lookup where expected (pos = %d)\n",
-			       pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;
-- 
2.39.5



