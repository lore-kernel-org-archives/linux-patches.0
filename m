Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8778E81728;
	Mon,  6 Jan 2025 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178654; cv=none; b=UjqfPRW4OmAeY6Podf4a09NvMaYc4MlDfyw16NnXgFEt4gdpyrnhrWu0KnIcDkgX7WHul1PiNwcW1KzqdLwF6jEbsQVNH8y44MB77SZqaXCFF6kG4rUb25Eix9yjrLImYLN5CQooMP3n8y9NQ5zB+7oWUTOPEvgH5DWsa2Glq2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178654; c=relaxed/simple;
	bh=xVccuqbRZTvt33qyGmA63cZqAxlFG/AByEs3lr+ELcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJkKMbXsp+naI5fMS/IsyCXROOYh2rH6PmvkztKEWHTuYtON/vjLqACR6a51oVTey0hSW6UuGaZstnmeYUF7a6uBYkHO3ZbkFslA+sYKerbKGxxqBSCJb4WHuW8tpzko7GckIVk5aD+XJSBkObNEzU4DysIvPyTt2HFeu+XFyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEYhDWL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEYhDWL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A653BC4CED6;
	Mon,  6 Jan 2025 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178654;
	bh=xVccuqbRZTvt33qyGmA63cZqAxlFG/AByEs3lr+ELcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEYhDWL4s3R0e0t2M7GFS1X5sXXSewB7dKFblefi9kMTxdVIdWxoo4CSmfJbylFYk
	 yFQcBJTrqh3bdO86RJewfu/KA+3y1s/SCFxnEW0WGMn0I82dQcFx85qncPPy7prglw
	 cvjtIY8KC8JQfMIkYpHCLJUKrrZAbirfw4nJnZtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 049/168] of/irq: Fix using uninitialized variable @addr_len in API of_irq_parse_one()
Date: Mon,  6 Jan 2025 16:15:57 +0100
Message-ID: <20250106151140.316291386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 0f7ca6f69354e0c3923bbc28c92d0ecab4d50a3e upstream.

of_irq_parse_one() may use uninitialized variable @addr_len as shown below:

// @addr_len is uninitialized
int addr_len;

// This operation does not touch @addr_len if it fails.
addr = of_get_property(device, "reg", &addr_len);

// Use uninitialized @addr_len if the operation fails.
if (addr_len > sizeof(addr_buf))
	addr_len = sizeof(addr_buf);

// Check the operation result here.
if (addr)
	memcpy(addr_buf, addr, addr_len);

Fix by initializing @addr_len before the operation.

Fixes: b739dffa5d57 ("of/irq: Prevent device address out-of-bounds read in interrupt map walk")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241209-of_irq_fix-v1-4-782f1419c8a1@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -298,6 +298,7 @@ int of_irq_parse_one(struct device_node
 		return of_irq_parse_oldworld(device, index, out_irq);
 
 	/* Get the reg property (if any) */
+	addr_len = 0;
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */


