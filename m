Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458071482F1;
	Thu, 13 Jun 2024 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280556; cv=none; b=ZO6QmuSl2krObZXdRp2Ku40cqdfXiTTjge3r3CvXeCU4EcxGdj6OrhBDyjb62ez3d+dbBC8K9V8fBWyxksbCDjXrmAz/ojxUxcc5jr3bC/r8Mjg3hZVt9Oyi6WdPmM/rprujOwo3r4JuRgT74eJDau+e4IKNKD+3149UeKHUWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280556; c=relaxed/simple;
	bh=0bD9ePhHR5E1skqPOt1X/BxLDeQNSFQjPzeJ2ee9DrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVBOO5ks0QZ+tnZbaD/IWSeHRqwBQ3u8dwCnIz4VNy80FJR41oHmsrgr/lTCMh8CP4mSuMwuAGatg3BblAr9rHY0jlfJepGyZBaU1CTgIyYgehFTBfnJKAzrqaFfepmkArnuGeXVxsyiC0LTLSsKcRYJD8XbRauV6uFmfvzzjJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9E8qGhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9E8qGhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA218C32786;
	Thu, 13 Jun 2024 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280556;
	bh=0bD9ePhHR5E1skqPOt1X/BxLDeQNSFQjPzeJ2ee9DrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9E8qGhL3DhdRKRX20gbmj9+6T5D8c75TGIcRWpxo+uUwbJWU8GtUtuqL1kuoMVS7
	 Eg5jN7vTgi45kU1OLbtg629FYXOl9ET30BLL/zB6VspEWaOlOvGpzs3laEUE7VTyug
	 Gd52ctTCLVco7L1FEI4kBB6dAslaKV9nv8AMpA3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 093/137] selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
Date: Thu, 13 Jun 2024 13:34:33 +0200
Message-ID: <20240613113226.904650717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

commit 9ad665ef55eaad1ead1406a58a34f615a7c18b5e upstream.

Currently, the test tries to set nr_hugepages to zero, but that is not
actually done because the file offset is not reset after read().  Fix that
using lseek().

Link: https://lkml.kernel.org/r/20240521074358.675031-3-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/compaction_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -103,6 +103,8 @@ int check_compaction(unsigned long mem_f
 		goto close_fd;
 	}
 
+	lseek(fd, 0, SEEK_SET);
+
 	/* Start with the initial condition of 0 huge pages*/
 	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
 		perror("Failed to write 0 to /proc/sys/vm/nr_hugepages\n");


