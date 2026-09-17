Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2374D489B;
	Thu, 17 Sep 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660562; cv=none; b=G51Oo8vWgRw79z9isEn4x4Jlt4iPEBCoB5+Wbn35ITTvTGOqsfgW0h5P8ZA2nqvcoQsY/R1jFvPxPXsNf9PDcRSeHvHSpPI/SmxbXwkJ/cQT1Tk1hFL3VMc2Nr0L7JdQPaGnpIcEZvlKAbRp5qItgU/vFXwRKb7SLWK16LNHXbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660562; c=relaxed/simple;
	bh=priUIPW2t2a4V6hRpD8wKzW+SVbwAXuylEPSUa+hWQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBzWxqjMDzLigJCyi26yqDom5cSF37pMw1xLocx3uzaWlP0PyomLjQN5NjSUh7SRtG9rukTe9TmkNRP4DxRNh2HLhNw+kfRWfwKkLJUwlt5n+gq47MOJKfadVAD60solD/XjY40g9VMBnZqYwDMjScGaT6A3gRejB3JVT1nsXBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DI0Pmt/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DI0Pmt/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD011F000FF;
	Thu, 17 Sep 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660561;
	bh=1p79kg++tZbpq7fNnSljitIfCFvSdgJnqgcs88XI2VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI0Pmt/ltXA01FR4iVbXjIQ7nKmPyYn1MKJ0++66FjvM4UOg/Lkoky1Qj1R9H0cqf
	 gv4f9g7cq7dcauwlVuR/Hh/YwBitm1NL5Xt5T0r9aAnIzk0epOIqJW1zC4KGyp8oSs
	 joyk+TfHCgxvdSbyyR4E4hRCw6vLrAAITf2+QM30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 634/733] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Thu, 17 Sep 2026 16:15:42 +0100
Message-ID: <20260917151408.375099225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit 6bd360447941357e959414a525aa62576a448116 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1278,6 +1278,7 @@ bool cifs_reparse_point_to_fattr(struct
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:


