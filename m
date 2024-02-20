Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D0612D7;
	Tue, 20 Feb 2024 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463501; cv=none; b=TsEc9gi77Q9AB0qXnCL41k2PRlbSRcWFt/1hOoBNVB1+1piIJ1cb2glwZBLu6jaYOJCjTNXVuQAqvAWCFtiY9BGcpUrN021VgIKBmCL+6QPadqc4ZXOFGTL8QphPbbAJSb1/pc+M7BXX/TXWJQryAvRuxoD5v9h56OcsAEEmC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463501; c=relaxed/simple;
	bh=wxPOCCz22+O+OQtkVW/dv9u9vHzZUucRlDbgjEvS+kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ieqnm2tHeFg4vyjz/eEjPBUK+0SBqV2PsY37HlkpqucdAB9Rut0dIXZSNy73h8Re/qpKvhXZlou09SgbsibeBdCvKCPl7e/LxHqV/plaeAQ3Lhi8V+69zHxoW24JulRkgwFYwRFLsrg8aPWpg8vy7/n8JwxRGd+NVaqu0LjNEek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA5UG2je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA5UG2je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B611FC433F1;
	Tue, 20 Feb 2024 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463501;
	bh=wxPOCCz22+O+OQtkVW/dv9u9vHzZUucRlDbgjEvS+kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA5UG2jeunhna0YEjTFwt/AqzCpw55NtaYKiiZhxqrlbHdXF5DuXoQag0xIUhFXOk
	 BYG5xLATN+121sgtrNc9ugOMJ24/1OOaBcULP8OQAkoZbnT78yAsliR9SSWimEXgnm
	 BQZjgsOQ/FvacOQdK8KNLfjqezVCDMUzm7ZGEBG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Pache <npache@redhat.com>,
	Donet Tom <donettom@linux.vnet.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 063/331] selftests: mm: fix map_hugetlb failure on 64K page size systems
Date: Tue, 20 Feb 2024 21:52:59 +0100
Message-ID: <20240220205639.567760062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nico Pache <npache@redhat.com>

commit 91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

On systems with 64k page size and 512M huge page sizes, the allocation and
test succeeds but errors out at the munmap.  As the comment states, munmap
will failure if its not HUGEPAGE aligned.  This is due to the length of
the mapping being 1/2 the size of the hugepage causing the munmap to not
be hugepage aligned.  Fix this by making the mapping length the full
hugepage if the hugepage is larger than the length of the mapping.

Link: https://lkml.kernel.org/r/20240119131429.172448-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/map_hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/map_hugetlb.c
+++ b/tools/testing/selftests/mm/map_hugetlb.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include "vm_util.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -58,10 +59,16 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	int ret;
+	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
 	int shift = 0;
 
+	hugepage_size = default_huge_page_size();
+	/* munmap with fail if the length is not page aligned */
+	if (hugepage_size > length)
+		length = hugepage_size;
+
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {


