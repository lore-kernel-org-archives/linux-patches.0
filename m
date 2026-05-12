Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4C3EDE45;
	Tue, 12 May 2026 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609244; cv=none; b=r7JOntmyvvoZIBR45sV/Sowus4v4M6liUmkR/UG1v70V8PMWGkBvVFqbHkCiEwTJZ0VxCbL+Its86KQZ1pXOUtZaOe1EpyIOF9Koljw2/EtTb1k5K0dNHteIppXT2nbIQXLD76OdX5vfOMbjjlo7g2sDTZadUh5qE4yZ/IVHgxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609244; c=relaxed/simple;
	bh=JCyfv6J3qQD8r1e0ZFgcdVKdR6YicraR49tLSllVf+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTn20IlEMBP0oNwVtMwzXzDCHMLz4iijQe2kyi7c9HsBYBTSvctc0vjWomJUTaW4cwDiikNH8PHnwtfCabt6p/BpAUJaXcHMbShMbMTNTV3ImF8XIpsGU+R7HCgf5OmLxTy6LMitLCQpaLIPcjr8dBWNwGjgcf6wHETs3PhhxqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeiRJXz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeiRJXz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA1EC2BCB0;
	Tue, 12 May 2026 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609243;
	bh=JCyfv6J3qQD8r1e0ZFgcdVKdR6YicraR49tLSllVf+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeiRJXz2LspzkC6q9NiPfBp00x5USzbDAhZPqSTmQ1KB3l7ghUGaTg/yakBgvXE7F
	 mQQxfE8M6Z9P6nJkK5WEbtwsu+sJzw1azW+R6QDU/U0smHMLJdcQO8FE5UxGzHBvfy
	 arCgddsRQzbpj632UYt6n39Bea1nK7TZzICGOqDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.0 113/307] pseries/papr-hvpipe: Prevent kernel stack memory leak to userspace
Date: Tue, 12 May 2026 19:38:28 +0200
Message-ID: <20260512173942.508645307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit cefeed44296261173a806bef988b26bc565da4be upstream.

The hdr variable is allocated on the stack and only hdr.version and
hdr.flags are initialized explicitly. Because the struct papr_hvpipe_hdr
contains reserved padding bytes (reserved[3] and reserved2[40]), these
could leak the uninitialized bytes to userspace after copy_to_user().

This patch fixes that by initializing the whole struct to 0.

Cc: stable@vger.kernel.org
Fixes: cebdb522fd3ed ("powerpc/pseries: Receive payload with ibm,receive-hvpipe-msg RTAS")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/7bfe03b65a282c856ed8182d1871bb973c0b78f2.1777606826.git.ritesh.list@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -327,7 +327,7 @@ static ssize_t papr_hvpipe_handle_read(s
 {
 
 	struct hvpipe_source_info *src_info = file->private_data;
-	struct papr_hvpipe_hdr hdr;
+	struct papr_hvpipe_hdr hdr = {};
 	long ret;
 
 	/*


