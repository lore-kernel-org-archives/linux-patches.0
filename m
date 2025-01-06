Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ACA1DE2C7;
	Mon,  6 Jan 2025 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178211; cv=none; b=FqppXD7ohzkgwbxUxOTRLOLNarX79mV9MCgrKKwlCXu+e4pVTjaFaCHZwS/goUESWBJcumGoQ+YuDhyMqcuqtueeHepqemFxmXNYaLiFsOrV7Hf4nkeWFJhQs9T8FKSEd5gb0E/Zx7yDMZNt5n786UK8ggKxq2csAXINjq2mFwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178211; c=relaxed/simple;
	bh=WVdayttM5TvRNT8CiPW7VG97/Yxtd4mQ+SFo5OHaAnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6N9o1qZGy/krHDpAJSd3OQPTlrqWdKN9l0kKwAaZnYdUUr7EkwTXHxsM6h4bATk8ywk1zHtTjT5kuolCLzFPHnKJQkTYXRdIxZDH2cxvJmNS6kPsQqUS8kObqEAkM5UNnqJVVnMGKOYMlfeTG/qRMFWvINXWja6lxiQwTiWBfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8zfR7+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8zfR7+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47368C4CED6;
	Mon,  6 Jan 2025 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178211;
	bh=WVdayttM5TvRNT8CiPW7VG97/Yxtd4mQ+SFo5OHaAnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8zfR7+fprLkyeXTmujVv3SPk4brXQlLcruRL3PtU3aeE2tsk30daRVKLLxsy4/5V
	 kcfNxWI06uf4bppu6aoj5FpnxQiLop5H3OKkrGgvymW7x/LHfwBNHCnwR98THlEt2a
	 KqXbp8vhrpdDgI+CbQZfIpkQ30wFdGQHbXkPL2og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 5.10 042/138] ceph: validate snapdirname option length when mounting
Date: Mon,  6 Jan 2025 16:16:06 +0100
Message-ID: <20250106151134.830197218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilya Dryomov <idryomov@gmail.com>

commit 12eb22a5a609421b380c3c6ca887474fb2089b2c upstream.

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -301,6 +301,8 @@ static int ceph_parse_mount_param(struct
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;


