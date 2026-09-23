Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312C43F58D9;
	Wed, 23 Sep 2026 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174042; cv=none; b=no7LxV5B1TnctgNsY724n04ofJsIk+TQ7dSdwtbj8wuZCRe5Q6KWJTG68GWDmigK709IHa38tQ1BvmABjxwgbhFqGkBRdgvwOT8Fg538jTocEPscn9UEmE/wmLLbHkqICXyT123Kym7zkJbKMjBLwUht3RoMjNOAGaODiwiAuFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174042; c=relaxed/simple;
	bh=rkn5TFDuCnWb7Dm6oIilN8ojAHXjl4geoxDvoeJ6dq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZvpnhkBpvUr7PfqX4xJlPn4eLOrFIhhO2elrI4rgbbqRqVfONCadLAFA4rQKRFWl8LDc8tr5o30SclZ4wMG0m/KYDGFe/wr3n5FYrCv9+o1z9dx8hIQLvKXjGALLfbvaRA+0LfJd81/u3Nf9Bp7mP+Dfw3QCwz6MiazLx6x1Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YSJYL3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YSJYL3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB371F000FF;
	Wed, 23 Sep 2026 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174041;
	bh=4hvZqNFSY6g0Q31+RzJoqzkoLCRAlHe2KETDYex06p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YSJYL3dM02TlbCzXt79vuywXGixEA5meiZdbPmBjJpIx/2utzyaufxumQRsz++MM
	 USeRIdyBax4gWSIy4IPgZvIldlI6RyT89V95uHK03vOExV1135Mij3bziu1VWAXezq
	 cOTrxKKXpTKYcisWjnqOuf1qYYaO+8dB+4JOY4aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 417/438] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 23 Sep 2026 16:07:18 +0200
Message-ID: <20260923140655.719704474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 1b3221bb121079ad79a1f3c3aa360ba649832e7a upstream.

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -785,9 +785,9 @@ next_iface:
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}


