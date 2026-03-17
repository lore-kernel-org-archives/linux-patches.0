Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6D13BFE59;
	Tue, 17 Mar 2026 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766571; cv=none; b=qVao15a1HvKvJSg1/5JcpeKJoSDUtelWuDNKN9TfvFJi1lmACGvblD1AgfvOBVgrmc4zaTy9bwSXH3PACb3UwE5VJ5AOow2PRA1QMnohbkcBybC02CgX/fp1ZfYB570sjsBTujQzD0RzkmS2f8hvHEAjq0nZ0TKVYjmCVPqa1S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766571; c=relaxed/simple;
	bh=pr7SntCU96RTPt5Uhk+82MEnQHuHEacJaohpwGLK9xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcyYRys+kJ8RFyhS7IiGK/087ega4PTqJHfovIFRagTU6easY8RilSf9DMdfOK/X6xhd4bPbGsNOUzegCMQ+0u9J+/B1xuktdeyhcT1eQ7qwFZQHCfjkN0v1rAPbXSUWruo17iM5jIv0LIpaws2FmMB+QmSD0FkzUbofSX/WaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEfCmPbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEfCmPbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17DFC4CEF7;
	Tue, 17 Mar 2026 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766571;
	bh=pr7SntCU96RTPt5Uhk+82MEnQHuHEacJaohpwGLK9xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEfCmPbdoLbsxwkWW6KoHBW2kccIMVrRhya4SM0PSjeqg3AFTLNxuBlq2zapH0tiE
	 RZexZ8zxhY8BgooP4jeRwgmRVdzZ3b3h2G8AnMWW9bZWPwALnXFzp+irG17InV+2A8
	 LIbDdqiSbxeCem38Zv04UHS8Qz/+bcI/PcJebDjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 232/378] s390/pfault: Fix virtual vs physical address confusion
Date: Tue, 17 Mar 2026 17:33:09 +0100
Message-ID: <20260317163015.545911765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit d879ac6756b662a085a743e76023c768c3241579 upstream.

When Linux is running as guest, runs a user space process and the
user space process accesses a page that the host has paged out,
the guest gets a pfault interrupt and schedules a different process.
Without this mechanism the host would have to suspend the whole
virtual CPU until the page has been paged in.

To setup the pfault interrupt the real address of parameter list
should be passed to DIAGNOSE 0x258, but a virtual address is passed
instead.

That has a performance impact, since the pfault setup never succeeds,
the interrupt is never delivered to a guest and the whole virtual CPU
is suspended as result.

Cc: stable@vger.kernel.org
Fixes: c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address spaces")
Reported-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pfault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pfault.c
+++ b/arch/s390/mm/pfault.c
@@ -62,7 +62,7 @@ int __pfault_init(void)
 		"0:	nopr	%%r7\n"
 		EX_TABLE(0b, 0b)
 		: [rc] "+d" (rc)
-		: [refbk] "a" (&pfault_init_refbk), "m" (pfault_init_refbk)
+		: [refbk] "a" (virt_to_phys(&pfault_init_refbk)), "m" (pfault_init_refbk)
 		: "cc");
 	return rc;
 }
@@ -84,7 +84,7 @@ void __pfault_fini(void)
 		"0:	nopr	%%r7\n"
 		EX_TABLE(0b, 0b)
 		:
-		: [refbk] "a" (&pfault_fini_refbk), "m" (pfault_fini_refbk)
+		: [refbk] "a" (virt_to_phys(&pfault_fini_refbk)), "m" (pfault_fini_refbk)
 		: "cc");
 }
 


