Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88305188006;
	Mon, 23 Dec 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970115; cv=none; b=qN70BqGQSYW46cV2IpmRTMCGFQnCgRBXxDYPJrmu8NjzuWzPQU0Oj5Tei75rgehd38vwQ4436ofrw1pIcnXXN9oEw687Dg1McraciSUlMVe4cXEPSGF/ifjsYbrZn8PN2BvVlahkG0QLK2WtHGjTj3g8+6Ln2i70wTshDdnjib4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970115; c=relaxed/simple;
	bh=Tcxagf8i0yLnTf+6hNMmKYtDcb9/TdUcryd6w16jk5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upSSJqZOsFB2NTvE7pUehk0xLrYmCC+6fVRIF4eTRtJMX9G/SxAFmlpr6ovAUJ37QgVDcdGOzI9qR41YUPdYw+cO+yQDPj25L2yVNKwA2kQp2DKGyl5nUW/w5qEJInF8xz4GLaR+xunzhOjuDSpTB3X459njY9IjXdyfEFu/x5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TopBEIIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TopBEIIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA86DC4CED3;
	Mon, 23 Dec 2024 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970115;
	bh=Tcxagf8i0yLnTf+6hNMmKYtDcb9/TdUcryd6w16jk5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TopBEIIKy/x29UEND6IkNt1PXImnesnDPL7dP7NcAaPdN1aD4XNmbeJSU6PZlhOGS
	 aYvJLsCsTIJuXzipSy4rMn+9o7asldYis7Ju9ei8KAumL8dq6oQewyQlDTNvp9Pz0Y
	 b7IlBL4MloobJLeqSPZWd8EAjsKb7jhL6jiF5ZEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 118/160] s390/mm: Fix DirectMap accounting
Date: Mon, 23 Dec 2024 16:58:49 +0100
Message-ID: <20241223155413.321697218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 41856638e6c4ed51d8aa9e54f70059d1e357b46e upstream.

With uncoupling of physical and virtual address spaces population of
the identity mapping was changed to use the type POPULATE_IDENTITY
instead of POPULATE_DIRECT. This breaks DirectMap accounting:

> cat /proc/meminfo
DirectMap4k:       55296 kB
DirectMap1M:    18446744073709496320 kB

Adjust all locations of update_page_count() in vmem.c to use
POPULATE_IDENTITY instead of POPULATE_DIRECT as well. With this
accounting is correct again:

> cat /proc/meminfo
DirectMap4k:       54264 kB
DirectMap1M:     8334336 kB

Fixes: c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address spaces")
Cc: stable@vger.kernel.org
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/vmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -306,7 +306,7 @@ static void pgtable_pte_populate(pmd_t *
 			pages++;
 		}
 	}
-	if (mode == POPULATE_DIRECT)
+	if (mode == POPULATE_IDENTITY)
 		update_page_count(PG_DIRECT_MAP_4K, pages);
 }
 
@@ -339,7 +339,7 @@ static void pgtable_pmd_populate(pud_t *
 		}
 		pgtable_pte_populate(pmd, addr, next, mode);
 	}
-	if (mode == POPULATE_DIRECT)
+	if (mode == POPULATE_IDENTITY)
 		update_page_count(PG_DIRECT_MAP_1M, pages);
 }
 
@@ -372,7 +372,7 @@ static void pgtable_pud_populate(p4d_t *
 		}
 		pgtable_pmd_populate(pud, addr, next, mode);
 	}
-	if (mode == POPULATE_DIRECT)
+	if (mode == POPULATE_IDENTITY)
 		update_page_count(PG_DIRECT_MAP_2G, pages);
 }
 


