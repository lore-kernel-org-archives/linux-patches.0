Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C9176ADE;
	Wed, 19 Feb 2025 09:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957334; cv=none; b=chahE9hSvw1/a1ScWPQqYW0hsOsrQPKP0D8YtNuLbEw4Xlk2aUmfJfx7/Qc97Jka7WM21Us2RvV5kuhuhilg7aAf6S4lHh7hdbAhTk/ZDr97Gjn2G3Q1kVqBo3Ufiou7YYNrw7VWIU6FEEYOfBbGjaGt44HmIJka9sgugjNFcWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957334; c=relaxed/simple;
	bh=rCAWFhlhPQfPjeBg1SLYw/2qmFpWLfg6R2H9Mg8xN6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFasjuRCvvp99EEMF8qa9NA5wy2JMOXuhRlMDMkCNcTziclexCKc5bXBTMJuxNNWvru+0IJrgjiTGZ+LlnGP9CoxpIxqEi8FvNzfznpWeApgUZgvuVmJX9DdGYpV23zpMhdPS7fdaot2O17dQ0Dnd2SmJMyVAqenL99MI6jC390=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV3UPKrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV3UPKrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C94CC4CED1;
	Wed, 19 Feb 2025 09:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957333;
	bh=rCAWFhlhPQfPjeBg1SLYw/2qmFpWLfg6R2H9Mg8xN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV3UPKrRbF01tHBIyFycQvnTNF6dTH/vLoi2DuieRIvIxYK2mtTAag9+XtUUeWy5l
	 zW9cYBpqZFOg60gpdc7BxlcqUFl/2Pu3LI/6eaifHyyC52hGy1f45rHk+GvjWfWQe5
	 RIy+uMO8zoLjffmx7Tl1DKZK2Lc4sB9YBCY8UWO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Binderman <dcb314@hotmail.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Vernon Yang <vernon2gm@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 457/578] maple_tree: fix static analyser cppcheck issue
Date: Wed, 19 Feb 2025 09:27:41 +0100
Message-ID: <20250219082710.974895684@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 5729e06c819184b7ba40869c1ad53e1a463040b2 upstream.

Patch series "Maple tree mas_{next,prev}_range() and cleanup", v4.

This patchset contains a number of clean ups to the code to make it more
usable (next/prev range), the addition of debug output formatting, the
addition of printing the maple state information in the WARN_ON/BUG_ON
code.

There is also work done here to keep nodes active during iterations to
reduce the necessity of re-walking the tree.

Finally, there is a new interface added to move to the next or previous
range in the tree, even if it is empty.

The organisation of the patches is as follows:

0001-0004 - Small clean ups
0005-0018 - Additional debug options and WARN_ON/BUG_ON changes
0019      - Test module __init and __exit addition
0020-0021 - More functional clean ups
0022-0026 - Changes to keep nodes active
0027-0034 - Add new mas_{prev,next}_range()
0035      - Use new mas_{prev,next}_range() in mmap_region()


This patch (of 35):

Static analyser of the maple tree code noticed that the split variable is
being used to dereference into an array prior to checking the variable
itself.  Fix this issue by changing the order of the statement to check
the variable first.

Link: https://lkml.kernel.org/r/20230518145544.1722059-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230518145544.1722059-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Reviewed-by: Peng Zhang<zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1935,8 +1935,9 @@ static inline int mab_calc_split(struct
 		 * causes one node to be deficient.
 		 * NOTE: mt_min_slots is 1 based, b_end and split are zero.
 		 */
-		while (((bn->pivot[split] - min) < slot_count - 1) &&
-		       (split < slot_count - 1) && (b_end - split > slot_min))
+		while ((split < slot_count - 1) &&
+		       ((bn->pivot[split] - min) < slot_count - 1) &&
+		       (b_end - split > slot_min))
 			split++;
 	}
 


