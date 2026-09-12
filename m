Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF7F38837C;
	Sat, 12 Sep 2026 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228039; cv=none; b=Q0mNAX8qqwEJqGKnTHXpI5zs2cGueMlg0dR3rusMrd/G9LEEUwYmDbv8vaCy9Dk5kqiG9D6l8ZfKrgqc0NrOwj8NlWjQFuO73NlyXeQ3gHaiFV3YzfiPdLkjQFSfO4I2Io4Lnn59KU8jAlToQec8zWjdxPBrfT45HNLFAjfL13c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228039; c=relaxed/simple;
	bh=tSDiLCBNR4sn44w5n0sxkf2cW+JD8pJtpI9wzxfaEfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZc+HAWzqkoqy54mSrOk5ZiH+8lMv33ksotudL/z98Kzu2zYmv3fesTnIHKQflQMnm5D2+rWmUs489O8AD7vIOZpK07xz2r22wSqlFQmHb4CZZ6A0YXWeNA7lP6Be7ejsYoyiYfGzLb7Uk17S+NUhweMJB5hXtR69z8fHD15Wrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knmdvt9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knmdvt9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FF1F00893;
	Sat, 12 Sep 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228037;
	bh=tLaarvQGs/0ugtjxA6VN+ZMNqV6MsQAN6qzuWN17/s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knmdvt9ktzXH0wMqItmSABZgO+r4PK/HD+ypp52yDuj0/fgt62kfghHl6Zftv0edV
	 k3S0+6SkW9V/ECVPf+xWKdYrS7exIf4v+pGq7K4vs7tVT2NWBPiuUQ2AUyHY7u97cd
	 6f77MNQa16OaMmKk1XSDBQwqfD0XxLIUuOBd9OU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 0304/1191] i2c: mux: Fix channel node leak on adapter add failure
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065555.062839146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -433,6 +433,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


