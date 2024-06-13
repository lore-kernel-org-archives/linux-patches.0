Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C2D144D28;
	Thu, 13 Jun 2024 12:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281570; cv=none; b=amXRU/WNQhGiMYcYqWeQCKbCCn1hvg6eHbiKm873/R0awoxLvsWJsNwj5l5NinFP6YDeW5UpYnUvTdYB63f3rXHCIP40wNLwjV694izxB99S/qSy8hmsJmcfXJbCwRpiQlq/6aPF5H0Caestu/WUSBzVrzQSewiy+XCLZqhPFng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281570; c=relaxed/simple;
	bh=uO+l80iUXPtnxYw0zZqrBACoy3fPVH1d7g15KHM7eX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUXUvM7qWGj4IAKyY8ItZNeiBsqf5+sn+G22MD5/pDgEr1eGHSOfHrhBHGQqKLKSsJ7EI8JowWsV3VdjVR6tluJvknCBq7QiB9NczS3c0HWfibmp3YvZPjedNnqmwSVbc7qvbTPoasdnjIgvkp2qyjAenTJwdrPUKwzd8ph8D4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhFKfP7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhFKfP7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718DCC2BBFC;
	Thu, 13 Jun 2024 12:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281568;
	bh=uO+l80iUXPtnxYw0zZqrBACoy3fPVH1d7g15KHM7eX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhFKfP7rUrV55hH0rmN0JamFH7YAirm/ZpqWzwt+fG9LpI0/8tcsYp2cXPRAqQhQT
	 dt/i6VwGhE0M0iwCOTYwOUvJU2j3LIRNpejeHVBN7Pim20j6S9pleGZRD4CWnvA2OP
	 7NIlE2jp9b+ucEuVdWmq5GuMmcEDzOFEJA+xnGZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Henrik Sylvester <jan.henrik.sylvester@uni-hamburg.de>,
	Markus Suvanto <markus.suvanto@gmail.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 269/317] afs: Dont cross .backup mountpoint from backup volume
Date: Thu, 13 Jun 2024 13:34:47 +0200
Message-ID: <20240613113257.959161866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Marc Dionne <marc.dionne@auristor.com>

commit 29be9100aca2915fab54b5693309bc42956542e5 upstream.

Don't cross a mountpoint that explicitly specifies a backup volume
(target is <vol>.backup) when starting from a backup volume.

It it not uncommon to mount a volume's backup directly in the volume
itself.  This can cause tools that are not paying attention to get
into a loop mounting the volume onto itself as they attempt to
traverse the tree, leading to a variety of problems.

This doesn't prevent the general case of loops in a sequence of
mountpoints, but addresses a common special case in the same way
as other afs clients.

Reported-by: Jan Henrik Sylvester <jan.henrik.sylvester@uni-hamburg.de>
Link: http://lists.infradead.org/pipermail/linux-afs/2024-May/008454.html
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Link: http://lists.infradead.org/pipermail/linux-afs/2024-February/008074.html
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/768760.1716567475@warthog.procyon.org.uk
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/mntpt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -146,6 +146,11 @@ static int afs_mntpt_set_params(struct f
 		put_page(page);
 		if (ret < 0)
 			return ret;
+
+		/* Don't cross a backup volume mountpoint from a backup volume */
+		if (src_as->volume && src_as->volume->type == AFSVL_BACKVOL &&
+		    ctx->type == AFSVL_BACKVOL)
+			return -ENODEV;
 	}
 
 	return 0;


