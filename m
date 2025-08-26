Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B8223DE5;
	Tue, 26 Aug 2025 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213575; cv=none; b=Eu29A1S5fmn1lZKKWYDElUTXQBoBZgbU9/bJYC6Pm7LAq8knpTBikIkK7M7tu89NCDrjwjfIQ7I2pr3zuB5CAfHLUyywbL5WFtCE7gRIuUrqGpGpgKCfLS3eEP6tzylWFM2BTqWDzTDE8Tq2uoa1WcXvMQcvlWHN4AqQ9NdyjbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213575; c=relaxed/simple;
	bh=qKThOXvO/DrLiTUJ9+aCSPA1+6dfSSN4zh8RP+/jU6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbbw31t6ygoPJZUKUj0Cok8iF77PZtI7GUxgowlqxXw/qr+o+CoBWxS2KCKfF/3TJyuzbW4FBCJ0mTS/L8U7eUNPM+6Ar3d+hbq5vfw3jiVXt5F/Sdz34fH6MM0lr9Md7HyuB2Te23RYM3Mf0MyqQWRjWIUByssiu3Q2CniN2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv38SIiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv38SIiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332DAC4CEF1;
	Tue, 26 Aug 2025 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213575;
	bh=qKThOXvO/DrLiTUJ9+aCSPA1+6dfSSN4zh8RP+/jU6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv38SIiTPmK6KHWCji9niaDKpqPewtbEdPiRN7JrpdgD7vKIupI5obNBofry28j47
	 g31Pe6K4TU7PiAZ3GONeKvVoPTAtWtuRW/eQKBs/3irUX83jVbTaEHiXlrq6DVTgFr
	 K7VCijWgOg6LpxQSSqo9KVP9opOFScy+nchjo3QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 399/587] parisc: Try to fixup kernel exception in bad_area_nosemaphore path of do_page_fault()
Date: Tue, 26 Aug 2025 13:09:08 +0200
Message-ID: <20250826111003.073777533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
 


