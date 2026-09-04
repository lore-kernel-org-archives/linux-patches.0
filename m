Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E463D903B;
	Fri,  4 Sep 2026 06:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502367; cv=none; b=CvbuolZR2nDrNWn8wXMpfuWIo1pNkdaIcNpY5UQO/9fGMs2Zl0wy2YDa66wBDU6rZ5PfUSCO4mWEWd7mFHpeQ4aNqQRbmvVMF43u19HLTSwzYiSfkbifFmGQsFA8HgDgjbsc6V94Tn/vouSBsxjpl4e+iIP1FxGbmzIXRK04kjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502367; c=relaxed/simple;
	bh=MJx0CVDv2ULlAjxEL2yLOKlG+tsJ+7ONRpgSWE+tZCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/vbBVVDndIYFZtxfhEw4XZYKVdlyOuUtQYaVuZlci2s5KEklYmDgDEQvjqYmL9EozRuw5AEp/poa5HpoHOVdHYjeTft9/6izapSmTSx8vXaVO1VsDnulKK7ZVXE6wtsVW025rni6TJbU9x7oaoCQ2VHUMnOenw5O98AJM7cBXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8QU07Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8QU07Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0511F00A3D;
	Fri,  4 Sep 2026 06:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502365;
	bh=PXDs5UnrkqBsHmFY9Jns6uZoUpEtfTUYrDcCshd8Gy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8QU07LdlsKTh91TwNRa1YAdF4PuJJ+PbavSYC9PxXCXYnjS2fMew6oqmQocmrn7l
	 fET3sRYexjgndmJluqfzVOf8AMtiUFEb3Ss/6qhefamMklD2b1NbjAw9ZlqKDlLyEJ
	 m2ixWy67rB2GV+lh61xO7cB3v1enT0qtc5VFuDrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.12 139/403] ecryptfs: reject too-small tag 70 packets
Date: Fri,  4 Sep 2026 06:59:02 +0200
Message-ID: <20260904045738.002961426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit e97bbe1b2bd82ec2ae37ad2e4965b4d3e78bbf7f upstream.

ecryptfs_parse_tag_70_packet() subtracts fixed metadata fields from the
parsed packet body size to derive the encrypted filename size.  A
malformed packet with a body smaller than those fixed fields can underflow
that size calculation.

Reject tag 70 packets before the subtraction unless the body contains the
signature, cipher code, and at least one byte of encrypted filename data.

Fixes: 9c79f34f7ee7 ("eCryptfs: Filename Encryption: Tag 70 packets")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -937,6 +937,12 @@ ecryptfs_parse_tag_70_packet(char **file
 		       "rc = [%d]\n", __func__, rc);
 		goto out;
 	}
+	if (s->parsed_tag_70_packet_size < (ECRYPTFS_SIG_SIZE + 2)) {
+		ecryptfs_printk(KERN_WARNING, "Invalid packet size [%zd]\n",
+				s->parsed_tag_70_packet_size);
+		rc = -EINVAL;
+		goto out;
+	}
 	s->block_aligned_filename_size = (s->parsed_tag_70_packet_size
 					  - ECRYPTFS_SIG_SIZE - 1);
 	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)


