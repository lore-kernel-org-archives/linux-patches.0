Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1373BD63E;
	Mon, 23 Mar 2026 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283222; cv=none; b=fXQojfZcrs0D4sF6hEY2YlgYcVic+ZrHS4rw9R5oJK441zC6AuKbSMorQvH+mgDdOMfAD39k/9c0rEDSZiT/ah+aWm8I5Dk/ECXFY6MQ7CHA9Dq8RT2WbX9W2l1LlmDc0XX9y4ih7VvYjsdSpjoW6z0PA5biHZ2rjL791G+8Nw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283222; c=relaxed/simple;
	bh=gIt/7NBqmyutNzlad8fsQJZEGYbDb3AEtY5666O9AmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl0JNmGD0o8U3oIRU4n5G8uER4JPjRoSjmadodHRYeHBS0UHcJj/JSKt/eLq+9iW6D4sWt8bb/M1VdG/YgVZ17nNpy3zjko4ssYGxH/zTyDisiugZ6xU5w56rtjFV4WQPjstFM+ffxew1ekyteme/3dzuf2fj1ZQgQ3NcuEgrhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vuz7Gnrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vuz7Gnrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B36C4CEF7;
	Mon, 23 Mar 2026 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283221;
	bh=gIt/7NBqmyutNzlad8fsQJZEGYbDb3AEtY5666O9AmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vuz7GnrpuPfkq0HPRLUg7ox8LDb69OGQSJ3kairNql39t+oK2XeXuVkNiyALCpli4
	 BeZE2q6nzvJDvMtlDTz5jCwbqKJ8Nc4Ve06CfRmTNqpHs3Bdvh32TCp3gdI34N+781
	 neJErquqWNV2AMvNgBL56Q2rb5tzAALMBWa9G45A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 447/481] i2c: fsi: Fix a potential leak in fsi_i2c_probe()
Date: Mon, 23 Mar 2026 14:47:09 +0100
Message-ID: <20260323134536.108386541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit be627abcc0d5dbd5882873bd85fbc18aa3d189ed upstream.

In the commit in Fixes:, when the code has been updated to use an explicit
for loop, instead of for_each_available_child_of_node(), the assumption
that a reference to a device_node structure would be released at each
iteration has been broken.

Now, an explicit of_node_put() is needed to release the reference.

Fixes: 095561f476ab ("i2c: fsi: Create busses for all ports")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fd805c39f8de51edf303856103d782138a1633c8.1772382022.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-fsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-fsi.c
+++ b/drivers/i2c/busses/i2c-fsi.c
@@ -728,6 +728,7 @@ static int fsi_i2c_probe(struct device *
 		rc = i2c_add_adapter(&port->adapter);
 		if (rc < 0) {
 			dev_err(dev, "Failed to register adapter: %d\n", rc);
+			of_node_put(np);
 			kfree(port);
 			continue;
 		}


