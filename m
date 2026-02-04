Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFE8244675;
	Wed,  4 Feb 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216440; cv=none; b=rELn8betrFlcc6y2cNy2dIXh/DLOgLF1Q7t7L56nhyJHtAQ4GV2vq1Lqe7w+cKTYI5El5OYqwb5SxIuj6HtQnA5YyIl003VrMex6QYK5SuGjKl2z+SXc7JAOd2bGBuNOpT1/1PFkER8t7JTxRHLGNH36rVMooeSoDzSPepS1gGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216440; c=relaxed/simple;
	bh=D+X+EFep4PJnLmLaaRRo4Ezn8ey8cAn+qcVDkPo+qsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZlGReVKIdyuQUO9y53X6v3NRP3IVRrlzsE/8rkntl+FZQ+lSxZq0/ZNTcvCRUUSpW8FHsejtjyXlbYSJt8j6JTCykAXZ0DAZJnwMrxpmaZBuS4BD/7qKfJcjRGX4xDfnU3UBhI/JrvxhLUU8N+ZpW17eGncsrQlZq/s/FMYMj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5QlrrOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5QlrrOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990D9C4CEF7;
	Wed,  4 Feb 2026 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216440;
	bh=D+X+EFep4PJnLmLaaRRo4Ezn8ey8cAn+qcVDkPo+qsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5QlrrOX7RI8vYQsM5W7KeH5IV8OtbZaqlLTjSi3kZkqmNP3ZW0a+0M/0y4IFtiKn
	 WbEXpU3+iCyrv6l8KPY5PqJk4vr5MY3y5H4/WupFYbCuOpjdOwtEmmopT0mGjKu36z
	 vnKDXSs67lk/F7g/Ehf3q/Zn1rX+myLvBk8H83xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 088/161] of: fix reference count leak in of_alias_scan()
Date: Wed,  4 Feb 2026 15:39:11 +0100
Message-ID: <20260204143854.914158603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

commit 81122fba08fa3ccafab6ed272a5c6f2203923a7e upstream.

of_find_node_by_path() returns a device_node with its refcount
incremented. When kstrtoint() fails or dt_alloc() fails, the function
continues to the next iteration without calling of_node_put(), causing
a reference count leak.

Add of_node_put(np) before continue on both error paths to properly
release the device_node reference.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20260117091238.481243-1-geoffreyhe2@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2018,13 +2018,17 @@ void of_alias_scan(void * (*dt_alloc)(u6
 			end--;
 		len = end - start;
 
-		if (kstrtoint(end, 10, &id) < 0)
+		if (kstrtoint(end, 10, &id) < 0) {
+			of_node_put(np);
 			continue;
+		}
 
 		/* Allocate an alias_prop with enough space for the stem */
 		ap = dt_alloc(sizeof(*ap) + len + 1, __alignof__(*ap));
-		if (!ap)
+		if (!ap) {
+			of_node_put(np);
 			continue;
+		}
 		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);


