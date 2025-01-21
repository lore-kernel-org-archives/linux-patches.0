Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122891F540C;
	Tue, 21 Jan 2025 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483081; cv=none; b=ddXMxdvfaLMLlRHOS3GpAKtcdOLiA1+x3BhvjGOiwCw6HFbnvEdYV94ONDCE/HDs5HRQGpgm0NKjC0Q91nM4u/p+wVQdVWJQo+tz9HhOK1tD8PY2OMVyMgB582Iqx0DKPN33cIqssm0VrtY5tvXxqzuhlN/0e2NfVFGvVoZuMlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483081; c=relaxed/simple;
	bh=HBkjQ4cvjflpjvKn2EQWC9KT/63PM3RvfrBscCC7eHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADaLbOCW5808RAabY2k7WVMw0rF1H/DDkYVm9+k3ISdi5VVxy/41iGSge+ghGpl/TMsjLj01Fcf5W+Ar5g2pmFnV5zMsPnu9rc02vgPJAQcVExlSSW0qoIpsgCDS79dEd0lb2qUG2YzIsn4gazHbC/H79t8SdNlVtYyJF5jv9VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uf2ga9Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uf2ga9Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908AAC4CEDF;
	Tue, 21 Jan 2025 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483080;
	bh=HBkjQ4cvjflpjvKn2EQWC9KT/63PM3RvfrBscCC7eHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uf2ga9Dy+rq4Um0q0B1ogqptg9YnRa5QOjfFifiEExgwhq50aDYMAwl4CVsvFZoBW
	 17b92Oy6tcZTakvhMDJewzZn1U7bE4Wo08ppHDwEw9rbHcuCR32xGY4Vnnqq7F1Eci
	 jlzDwuSAMYzcrUVpFFrOqH+IB5OvdsHSpsdMbENI=
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
Subject: [PATCH 5.15 110/127] fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Tue, 21 Jan 2025 18:53:02 +0100
Message-ID: <20250121174533.891710274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,6 +396,8 @@ static ssize_t __read_vmcore(char *buffe
 			if (buflen == 0)
 				return acc;
 		}
+
+		cond_resched();
 	}
 
 	return acc;


