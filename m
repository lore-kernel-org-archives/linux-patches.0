Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACB726299;
	Sat, 12 Sep 2026 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241912; cv=none; b=J/Wwy/Il3GMcbSOOE9gXKFA9UJaGd2ZD3ZtJsZF7GJfIpBggkeLSapf/ByJgE/nT96GGNKsiNJuTBNCkkQjwpZM498b07RuiRbJ4xK4wKO6cJjGCtFS/5QH6cckQvgYAkWa3xw+1pC6ldNp4kEedfF6BDPR8/gKwA5CZS0kGEv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241912; c=relaxed/simple;
	bh=Mk2JOsmAsNhLIQ3B2qONjHvHWdoXxq5vLbRZRwPTuBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XytWcOD3pY32un8DdSBaNEOGPscGAcXxYIjKm0yNAwi+VVOYOjXkI5R87zTF+48kX6mjUpkzEipI6ABfbV/1cdsBeFJr7kqz7BKJVpeliUJJJWrCszTa/MNvFF3C1hRCfKqgiCFcMgnI24SJQVYzlim8En/ZKsfYGl8NmrRf8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDTeUCV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDTeUCV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1C61F000FF;
	Sat, 12 Sep 2026 19:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241910;
	bh=W2lGmINYOcMWru0J4vdC6kFAfJuJ+HHJVL3rhW3jmFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDTeUCV1C5+hyXA4Fpf9OA5QhYS0U81Y0IhtzFb0yDYFh3ZeA+rhCIzL+T96JvIX4
	 iOPHVYrlsgsA1YbMeu32nFEJvDUeJ4sKrVFrixMSiFoATZl7+MRkDddbEC351XtrZI
	 srkqWe7T+qujVVIZcMATXeHou1yNmaxp8XV5zVDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 232/798] i2c: mux: Fix channel node leak on adapter add failure
Date: Sat, 12 Sep 2026 08:57:40 +0200
Message-ID: <20260912065522.464087092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
@@ -432,6 +432,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


