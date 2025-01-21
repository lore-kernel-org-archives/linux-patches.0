Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FDB1F3FFE;
	Tue, 21 Jan 2025 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482490; cv=none; b=JJ/Zh6i75dBwjBNYibURzz6g0cdrfl4RcWrMoMH67f7icjuRd8LmqR8JeWXwrA0wg2YVi6ys/rdTO9kJir9RnJIITxN0/KLIeRyLEsYzymNXQVgah76zE3pEXx89qKhf8sinEkTj7kW8zCTSCC1ex5GcObVJtJRNuiT2UO3E1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482490; c=relaxed/simple;
	bh=Udxng/LlAxACw6O3UV8aZxrOC/B/q8UXwgdQUPlvtPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otFRrCJfZrnyeqFcozSOdcRZ4YrszJbpQPru4MYc466cK1wXNlflnuFpZD6Ksm+FNT7UgdaSKP4NEb9Alc/HUd8tRf5sT3GjnE+1T+65EFR/lvP3TZRVEtifL7u+FuhCyoBpRNuH4PK67V4guV7y9Ui8oBnhQ40Ev+Ms61bjAgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP27npwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP27npwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0AFC4CEDF;
	Tue, 21 Jan 2025 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482489;
	bh=Udxng/LlAxACw6O3UV8aZxrOC/B/q8UXwgdQUPlvtPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP27npwM9ciwc3zZiWJs98RfRd/W3NCrQBTQWCaKFI1LSP8DDSSQ9KNdazDRTawXL
	 pgRmX7kbkpeLxZQ1tg5b4j1sWVnrvlpDn2jpqFtHsEenz70NIx0t7Vm2rsrPoutKSE
	 /LvQSBdsifsdMxHF7rdMQYysPfJTOaBE9fxTmrFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Breno Leitao <leitao@debian.org>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 093/122] fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Tue, 21 Jan 2025 18:52:21 +0100
Message-ID: <20250121174536.607129165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Rik van Riel <riel@surriel.com>

commit cbc5dde0a461240046e8a41c43d7c3b76d5db952 upstream.

Since commit 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore") the
number of softlockups in __read_vmcore at kdump time have gone down, but
they still happen sometimes.

In a memory constrained environment like the kdump image, a softlockup is
not just a harmless message, but it can interfere with things like RCU
freeing memory, causing the crashdump to get stuck.

The second loop in __read_vmcore has a lot more opportunities for natural
sleep points, like scheduling out while waiting for a data write to
happen, but apparently that is not always enough.

Add a cond_resched() to the second loop in __read_vmcore to (hopefully)
get rid of the softlockups.

Link: https://lkml.kernel.org/r/20250110102821.2a37581b@fangorn
Fixes: 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -404,6 +404,8 @@ static ssize_t __read_vmcore(struct iov_
 			if (!iov_iter_count(iter))
 				return acc;
 		}
+
+		cond_resched();
 	}
 
 	return acc;


