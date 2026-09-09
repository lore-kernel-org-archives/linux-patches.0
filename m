Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D24C6803;
	Wed,  9 Sep 2026 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962016; cv=none; b=SM4IlKaL7FccTlH4hF1lqmhBSFp9aTOLc/CIiGoSNkzQogfO3Ax24Ia14QPzcPJE9TghVLM/9t83N9KMXB11yd096oPuaPY8l90zZrvGb0Wost9VwjMmqI/+MXW7ccQ6QwHovRp3ynF2UGRU8CidTp1Hf1/5vDjZqDK2Wv88nXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962016; c=relaxed/simple;
	bh=0edKHzRS3wbHL9TvArd36fAgKg+3nOHmIv+pRackRVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbOXPZKEidktcRBPB17DLFooNNF6a1SS9MLALmoU5hJz8lVYak0nPuX1N+UNGZmRYanZXTCpxjlp1Xy9zMtx4N5iNUmUGnXDeUd3Da8J0jzRbbe3n+jZIXYuWGlzKuzN0pywbulPqEvAsnssO1uf1BGeKj0n5U1WehtkIsa/qkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMLpF5G0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMLpF5G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121A91F00A3A;
	Wed,  9 Sep 2026 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962015;
	bh=+CnhE+IQtlXVFGOtNeXa0n83Sx4f+ju3RI9tSFRuy2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMLpF5G0RmZLoJVGG9WyAHI4Hrc34ZIrEZQmc8NuVIXiNsVwNdo0vVTc+L0IHWfyf
	 lZ0tJATg8SpIqC84v5ql3JJZf8UNjCLOEyRoDe+T/58nA28EnhwIvO6PhbcMCP/HNf
	 oNjCZ+wg4WbfG6QxJxwaJjvaixlehqMHqP56Xv1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 144/556] i2c: mux: Fix channel node leak on adapter add failure
Date: Wed,  9 Sep 2026 15:37:04 +0200
Message-ID: <20260909134235.514412227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 385c7af4e3b95d0769fd211831674e83b16a2ebf upstream.

i2c_mux_add_adapter() takes a reference to the Device Tree channel node
before registering the new adapter. If adapter registration fails, the
error path frees the private data without dropping that reference.

Release the channel node before freeing the private data.

Fixes: bc45449b1444 ("i2c/of: Automatically populate i2c mux busses from device tree data.")
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Cc: <stable@vger.kernel.org> # v3.5+
Acked-by: Peter Rosin <peda@lysator.liu.se>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/b3e46bbee781b3cb4029aca9a71316cc5e36dc17.1787502619.git.ahmadexp@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-mux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -408,6 +408,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


