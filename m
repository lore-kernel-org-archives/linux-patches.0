Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A920B7EE;
	Tue, 26 Aug 2025 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207298; cv=none; b=GyXe+9tpORqx/PDcPk6UFjyD9LqtZEy53iPwKXZYUvEE2D2C6tomy75Z3kFN2Slx50RwK0lABtKJW1ejApYNTOQYFkwlNeOmC1TEUXVTmAn8AthxkTZtyOG4Wbl+hj3VN5y38xwz+M52ZgZDh+9jr11OTz4DFL1qdv9uBMG63ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207298; c=relaxed/simple;
	bh=futG8wvKRf7kSJ9HKysUS11sYxwixOB1e6Sg1Sz/ohg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3bMDCDbvgv/x8dpz+UXrqJdlyvB5TA42ngtRZf8stn1w+gvfmG1gKHmspfKoJS92l+ZvizUcs+JuZM+J7b/gKe8I6Qvxgr/0uU2ZAzmt5IkeaaF5cNcWXI+u6aGZS0LD/vtS66pgDjINqMe1JCQmzfWx2DIMbn8cCv++9aZPEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNEIRYIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNEIRYIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A4FC4CEF1;
	Tue, 26 Aug 2025 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207297;
	bh=futG8wvKRf7kSJ9HKysUS11sYxwixOB1e6Sg1Sz/ohg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNEIRYIAgfxF7RRgJpLSrQXLPErM7v7U5MJGRM/Sppk2qlAxZa27GduIGkvauJ5Zj
	 85sE2Xrhex5rRTqOyKu6rWqPWx16RQYi00XdB36hgtQspz4dSlky6skR0hBdkZ0HFK
	 Jw7K1GndS2DlqKksE9JiK1WJMpCfUZuJJmQO0SMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.16 128/457] parisc: Try to fixup kernel exception in bad_area_nosemaphore path of do_page_fault()
Date: Tue, 26 Aug 2025 13:06:52 +0200
Message-ID: <20250826110940.537129474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit f92a5e36b0c45cd12ac0d1bc44680c0dfae34543 upstream.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/mm/fault.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -363,6 +363,10 @@ bad_area:
 	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
+	if (!user_mode(regs) && fixup_exception(regs)) {
+		return;
+	}
+
 	if (user_mode(regs)) {
 		int signo, si_code;
 


