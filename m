Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8F1F55FA;
	Tue, 21 Jan 2025 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482689; cv=none; b=Td6cRe08Es66DrHjSX+YGwB/NybyepHLHy7WGwo9QiSWmCbuKJ35bNYg3zKMfbNKbMJI9Sqg0qSkT4cAUtfcdUCPV/2INGiRSlRtnTX1CM4CyvS8HWeBmzqcaRGnGKNZUBj83Z/Ddubv6mcUmbJIhybGuwLJfkChvQI1FYV//EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482689; c=relaxed/simple;
	bh=inY4IZjI1ncpszNYoPlt//lmdZOxxBN56Zq5HxRb3Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTKiCjlOSV7HpYTNJdKBiz9y1/CGsuHDW4LTpLAIZD0FHI/t8QBn7Rt/TX8mqePOcrKJWY+SLMN9/qX2XDa3OB/wxx8ezKf6KBy1/E9JU1u6pLgnqKDsL5jzO6lbSD6MUl1Px/KwGcHHCbnI62UWD+UmzkOw2eTCRtrqcKgp5qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j45DlxAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j45DlxAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749D3C4CEDF;
	Tue, 21 Jan 2025 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482688;
	bh=inY4IZjI1ncpszNYoPlt//lmdZOxxBN56Zq5HxRb3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j45DlxAjH5MnjEQx8tYau+gAo9Uu3TkFnXDFDVOvjYto5eJ7fQ4MNatgP53cMetOR
	 3edqcDiuKQvzf2EdIxhYLfVkOU6INlqi6XdH6IKg1wL1kyb4kFyzvgX6/WFBEW00SK
	 mizdn3u5xvEP/aJTJvnLF5CGXvXOLBzdWsGQFvek=
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
Subject: [PATCH 6.1 40/64] fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Tue, 21 Jan 2025 18:52:39 +0100
Message-ID: <20250121174523.083127262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


