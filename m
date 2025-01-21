Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A43B1F76AB;
	Tue, 21 Jan 2025 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482236; cv=none; b=ChLcSp7hYicY7KywOi6YVFARZ6gUsaGzCnS4z0TTIIbZ3i3bAVmSiZGo1ZLVE/a+fTpXLZg+rSZAtV/62OVG/oJRcz8VwlQguqCNjT63ePWfkUTTGUJqQUikRlEPO9IvSG6zKi//qNwqnNPT4gahcBWLsYSDvam4KI64GMHl9b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482236; c=relaxed/simple;
	bh=YWRLoJHxoym7MbkIxtPkWqDkIlAxytW33BQKMPGQ6ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+NhkgUCuOfmpldahHYCHrPouR4Nrp0FZX0d2hVUCWgdgH4DbxMQlJovC9M8tsJe+PMdDDLgxPqIN26u1X/G3b+6AHCVu7IcH+LH6j8pyboTTpqrPcR2MOUj+La8G+ExUz4iJZv07AuxYxP+FO2XCR2eY9/AJiuIcsO9YB+lIWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oryVYX3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oryVYX3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C86C4CEDF;
	Tue, 21 Jan 2025 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482236;
	bh=YWRLoJHxoym7MbkIxtPkWqDkIlAxytW33BQKMPGQ6ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oryVYX3N6QmUQhNWBc4TmH8jnLlI2fbgonaKIE0IQmNOPnB0oa3zFufLEuClx6eK7
	 4wNptZrpSEr1wotOpiUsgIHSlOTnQqHVhPXvEUVcO7t9DksGvJZ+2RaeG4MBMNJDH/
	 28Opgsl6wWRIdI3UYgZvD8iY9qXAy6AWrfkinTcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 51/72] filemap: avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:52:17 +0100
Message-ID: <20250121174525.391502560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Nelissen <marco.nelissen@gmail.com>

commit f505e6c91e7a22d10316665a86d79f84d9f0ba76 upstream.

On 32-bit kernels, folio_seek_hole_data() was inadvertently truncating a
64-bit value to 32 bits, leading to a possible infinite loop when writing
to an xfs filesystem.

Link: https://lkml.kernel.org/r/20250102190540.1356838-1-marco.nelissen@gmail.com
Fixes: 54fa39ac2e00 ("iomap: use mapping_seek_hole_data")
Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3037,7 +3037,7 @@ static inline loff_t folio_seek_hole_dat
 		if (ops->is_partially_uptodate(folio, offset, bsz) ==
 							seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < folio_size(folio));
 unlock:


