Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8A814375A;
	Wed, 19 Jun 2024 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803353; cv=none; b=pwwhMUJY9ku99OsM95K3Mc3H07lcITePZ3Es8ML3zusOvVXXRCqjep8eF6R6nSPG9P+4qOpb2HuGak8tLuraIYR+PYyS8d4BwDKJvcOHhvGyvo+ojGlNv2GewaGQC4O9Yeu98Fv61DVequtZoHWBpJobxampfim5NUYvBiPhh0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803353; c=relaxed/simple;
	bh=l/c0aGzW941c/uodfuaysiQrvdZAQ3snSzsVk/ggPoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toWEpGuKsv5dLGpMpsH0Oo4zjEEVQnEN4qUG/ucfVP3DGDFqHRSc76d3KEHIhKr4PC0t1AfxJjXZICR6gMFMFLDykcDL9W7M15quf4MqV7gH6ziNxF+EiuSaPVZpDP4DePklyLCVjJJEGMQ57B+RoSBAkY2ITo1LvC8FAX9PwO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsGv7KHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsGv7KHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D20C2BBFC;
	Wed, 19 Jun 2024 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803353;
	bh=l/c0aGzW941c/uodfuaysiQrvdZAQ3snSzsVk/ggPoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsGv7KHjbF7ZANbS+XOHC283R1w60Sde9/sqjicLbGmYLTpszmQcxLuwKyGH5fA/x
	 r4bFESmw3CufJUgrogO1OatIMxIjEEiJLcSwTcKgz3SpWLyxjVqTmvHa+nRSDyrDGC
	 ZmD2ZFNxEoe0Ncnw2FWS66FFTI54JwBHkgA/+7sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 238/281] kexec: fix the unexpected kexec_dprintk() macro
Date: Wed, 19 Jun 2024 14:56:37 +0200
Message-ID: <20240619125619.120088154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

commit f4af41bf177add167e39e4b0203460b1d0b531f6 upstream.

Jiri reported that the current kexec_dprintk() always prints out debugging
message whenever kexec/kdmmp loading is triggered.  That is not wanted.
The debugging message is supposed to be printed out when 'kexec -s -d' is
specified for kexec/kdump loading.

After investigating, the reason is the current kexec_dprintk() takes
printk(KERN_INFO) or printk(KERN_DEBUG) depending on whether '-d' is
specified.  However, distros usually have defaulg log level like below:

 [~]# cat /proc/sys/kernel/printk
 7       4      1       7

So, even though '-d' is not specified, printk(KERN_DEBUG) also always
prints out.  I thought printk(KERN_DEBUG) is equal to pr_debug(), it's
not.

Fix it by changing to use pr_info() instead which are expected to work.

Link: https://lkml.kernel.org/r/20240409042238.1240462-1-bhe@redhat.com
Fixes: cbc2fe9d9cb2 ("kexec_file: add kexec_file flag to control debug printing")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/4c775fca-5def-4a2d-8437-7130b02722a2@kernel.org
Reviewed-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kexec.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 060835bb82d5..f31bd304df45 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -461,10 +461,8 @@ static inline void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages) {
 
 extern bool kexec_file_dbg_print;
 
-#define kexec_dprintk(fmt, ...)					\
-	printk("%s" fmt,					\
-	       kexec_file_dbg_print ? KERN_INFO : KERN_DEBUG,	\
-	       ##__VA_ARGS__)
+#define kexec_dprintk(fmt, arg...) \
+        do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
 
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
-- 
2.45.2



