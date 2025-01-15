Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA0A248BBF;
	Wed, 15 Jan 2025 10:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937534; cv=none; b=VXLUxjfi5fzN/2zuqjkbQkeAvEokKwhzeaFme5iFN8uvVZ4kqhoNEWI7tQ73+4yW1yILdkHQW7l9t+9EWMpVAUQnoOKx3UExgQ2QGgi0YZohx4egtpmOAWHnxZR+Iif2kK4JRYEfzbTNKczMWPhVkxLtYVbSOJ1hODASq7y/qrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937534; c=relaxed/simple;
	bh=uemHpkaJiWzJa66Fkzw3h+8L61HfLAJ88oMcCMtvhAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2zbVx5KCGCVr18IEr2xhXlZdUR04F2SMqrnDR4+CWnlMFRX3oKjWCcxVjrljsmnSO2wspKroMRiDkyg7+ml09dMgMEYJbO91+bZKIAKqjMurpu9/8c51+gj1TlDqJsKgXn25lK58Aqzy2kdI2Dt+eTlo/iwNWPva4OoJXmA7tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jA/0aouq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jA/0aouq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CBDC4CEDF;
	Wed, 15 Jan 2025 10:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937534;
	bh=uemHpkaJiWzJa66Fkzw3h+8L61HfLAJ88oMcCMtvhAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA/0aouqtwtHmlWBzkEcuV06m4Sy43vVqnbnzQiP4Xd7mYJiAdvxI6aOk+6Kew3oq
	 ONtlCH4a9hBF3UmtZ72ovNwUMCXfIRc5eeq7dJ1VSjD5szw2LVQ2cnCbd5/n5rYLHn
	 VHIwHcGry2Fr5WtS4YLuUiwQfd/WJCvNKVLTAL88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dario=20Wei=C3=9Fer?= <dario@cure53.de>,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 01/92] ceph: give up on paths longer than PATH_MAX
Date: Wed, 15 Jan 2025 11:36:19 +0100
Message-ID: <20250115103547.583898967@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 550f7ca98ee028a606aa75705a7e77b1bd11720f upstream.

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
[idryomov@gmail.com: backport to 6.1: pr_warn() is still in use]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2447,12 +2447,11 @@ retry:
 
 	if (pos < 0) {
 		/*
-		 * A rename didn't occur, but somehow we didn't end up where
-		 * we thought we would. Throw a warning and try again.
+		 * The path is longer than PATH_MAX and this function
+		 * cannot ever succeed.  Creating paths that long is
+		 * possible with Ceph, but Linux cannot use them.
 		 */
-		pr_warn("build_path did not end path lookup where "
-			"expected, pos is %d\n", pos);
-		goto retry;
+		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	*pbase = base;


