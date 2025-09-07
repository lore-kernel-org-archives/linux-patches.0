Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E781AF0B6;
	Sun,  7 Sep 2025 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276284; cv=none; b=jBTNej87mNC6DeRR7saOakb4rtPUVxgS21rlZ3LyzmRbppf05G7jut5ulGPuROthmCdW5epYfFPIeSCVJtLVUi30D+9D5PxrgNiyZ8kb8Ghwl9rTQH5q9jTxfoFIg5d/xUyjJldCm9bwA6jAMyp7MVlX7gMaarezUJKnef3NjWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276284; c=relaxed/simple;
	bh=ZwkILo+7bANYFJVxpgv7xK4QYly9iWbCursW/EBjZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8/FFLAGUkAcfp72kHIsmICSyTWLSPu4vyxQSUDlm2xOQOqBsIuVGTBoix7cc6Bl53igwqo5M4zPYVOqrSP/LxjsgqeTWCGZ9CENqCXOhNW/WjfAGieDulcpXLKiCn+KPp312PW5oZ77WIEvhSeYE9ELU/EsrTXTdjK1hIqqP6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGAzi1us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGAzi1us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D43FC4CEF0;
	Sun,  7 Sep 2025 20:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276284;
	bh=ZwkILo+7bANYFJVxpgv7xK4QYly9iWbCursW/EBjZ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGAzi1usXX9yPE55PXNBsqZ3/UVyv+XP2N428RIL7+zPuCNag+UCfPwTuV3mMk/VC
	 W0bhMHrp/bnYudXX2Rurgd0DMr9VkhFtXgOAHlzuE0YMWB9K/m09gVonxcDNFirknR
	 KHFJ1WwlfZLtisEtg6aw5q8s00Xec+tStZcfMtPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiong <liqiong@nfschina.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/104] mm/slub: avoid accessing metadata when pointer is invalid in object_err()
Date: Sun,  7 Sep 2025 21:58:11 +0200
Message-ID: <20250907195609.086456590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit b4efccec8d06ceb10a7d34d7b1c449c569d53770 ]

object_err() reports details of an object for further debugging, such as
the freelist pointer, redzone, etc. However, if the pointer is invalid,
attempting to access object metadata can lead to a crash since it does
not point to a valid object.

One known path to the crash is when alloc_consistency_checks()
determines the pointer to the allocated object is invalid because of a
freelist corruption, and calls object_err() to report it. The debug code
should report and handle the corruption gracefully and not crash in the
process.

In case the pointer is NULL or check_valid_pointer() returns false for
the pointer, only print the pointer value and skip accessing metadata.

Fixes: 81819f0fc828 ("SLUB core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Qiong <liqiong@nfschina.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -927,7 +927,12 @@ static void object_err(struct kmem_cache
 		return;
 
 	slab_bug(s, "%s", reason);
-	print_trailer(s, slab, object);
+	if (!object || !check_valid_pointer(s, slab, object)) {
+		print_slab_info(slab);
+		pr_err("Invalid pointer 0x%p\n", object);
+	} else {
+		print_trailer(s, slab, object);
+	}
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 


