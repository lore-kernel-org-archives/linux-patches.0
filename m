Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348A3090CE;
	Tue, 26 Aug 2025 11:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208400; cv=none; b=LQt6sJ0HuTTe+Arpmzf/Yk9ItLJMhKYXnp3scfsiF3KnHTxj4ni68277GYPjmBE51vEnwPhF9SaBxbc6fLmNFOwDk2+NZfqsyt10AIRZA2sl+360vUwmUV3pIexBcvTFi3oeuKp8zA7BcFLEXmjUqW9PfXJ5ITTFsn7q/tLetKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208400; c=relaxed/simple;
	bh=yCfm7RUK4SOZNkvdEM1RaYa6ApxsYb+ay7ybYdj2qQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3bqIYp1PpKoeDMVVlGkNL3oUNxJKBSMSo+A+YC2QuydtRvl9yOKvh/JPNY0RwibhN5UYutnXfBQxRI3Vzd7j3yfDSWZHMPbOAKJSg25js4qNwW0W5qBn3pE0C3iU0URjhSHmZLYPKCEGOsTncrtssnhu5iTPY8SOSesoBFzH9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xk0dKotl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xk0dKotl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6B8C4CEF1;
	Tue, 26 Aug 2025 11:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208400;
	bh=yCfm7RUK4SOZNkvdEM1RaYa6ApxsYb+ay7ybYdj2qQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk0dKotlVEQFxorEFXc4ftL0eUIjiogv6oW8WwllFRd6k+f2nDzzJwWMcCaZRfV4z
	 ObGYRjifyzp34p5FRWJXkIF8rdky9yh/NXgaA0iEBp5mBJ660UrKqlN0RBA27lCb6o
	 ifrsAl3KJq6Dz+cT/B7YFC+jZCh4iKOmYzW7wC5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 096/322] parisc: Try to fixup kernel exception in bad_area_nosemaphore path of do_page_fault()
Date: Tue, 26 Aug 2025 13:08:31 +0200
Message-ID: <20250826110918.053547386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


