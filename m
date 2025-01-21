Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A51F5438;
	Tue, 21 Jan 2025 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482788; cv=none; b=thDF86E44xVWLVqabiV6bCyGn2B0VHKPzmPfaP1jbotmk4XHcBWGgVtuh4fNZTFU6YXigq6j1b2B1Gex/g5YGs3+zIgztDkV/mqcmAlpfHKNdVHUttnwoRCIbww5BEtSVU2OEE0pCbATMcbXnQbXFdJZcmfJoAvxLi8ZXYUP1Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482788; c=relaxed/simple;
	bh=HtiltThA024Y+0u5Oo0UOsCzzRo2PTnC1OzGdmxBVoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDianU96SaVNrTPXdJB/aanpnAG4kUjN5pRjtdBxa6NbEF8envdMcDhY9ECA/sMdQMw9khcrY00UX9j+TWMcsyI8L1WPqAhaTBhBQt5xp/WqGdRFgyyy+KoV7OKzd17WfcPHs1MkWNr9s9S/8A1JicYN24Asj3NpNRBzpCNgAXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JocjkZSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JocjkZSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A662C4CEDF;
	Tue, 21 Jan 2025 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482788;
	bh=HtiltThA024Y+0u5Oo0UOsCzzRo2PTnC1OzGdmxBVoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JocjkZSthGvWZ8l9AX5JF5PAQEh3/kM7cI8BwgjZ/2EStvSkhUrOvMYeMoIK4Gh7X
	 MNYFU8gnQYmUxOnLJMldPqhToNplcTtNvF0oRftxnIMNr30lgp6NwTJWxi9c3c7a7p
	 0VUC1BMomIXgYG92IBRjMbNQyqAa8nB/oIkSodVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dario=20Wei=C3=9Fer?= <dario@cure53.de>,
	Max Kellermann <max.kellermann@ionos.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 001/127] ceph: give up on paths longer than PATH_MAX
Date: Tue, 21 Jan 2025 18:51:13 +0100
Message-ID: <20250121174529.733285041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2432,12 +2432,11 @@ retry:
 
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


