Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12A71DD0EF;
	Tue,  8 Jul 2025 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993299; cv=none; b=j06TWPwwjaSjhVaWA7VuMWYaRZqHWe7/ZoHjRex9n4r1aqQKWCBfCA4Ig9g8gx21MniE737AurFUjKGFeaFgL18OVe0sfBlLeAZXtuOpjt3JsSe8VrAqV2qEwbTDY6VHsR7YfVKXGlxhhyIX0pBWV/qDG14tvQGhoH+pLAwEp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993299; c=relaxed/simple;
	bh=0TYRbAN25owuAGaqg5SKW+m3fdWMh/BGXbY8cQdlihs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkJz2xe9fxlYbdBCe7WrksJ/+6mLJ281r7FXmmpLXgF0sVxK+JErgaFe2/7G5VSUQMxn0rZU0CKx38H327RakLbuUtUw0Qq7S+HtDKSoRMl83qkRwKBB2YYXWY9gzGqCUMzI+Gk6olcw4mZC91ZHib7FS0sYWs1LYmHd0FauHGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/gCdbC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/gCdbC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A355C4CEED;
	Tue,  8 Jul 2025 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993299;
	bh=0TYRbAN25owuAGaqg5SKW+m3fdWMh/BGXbY8cQdlihs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/gCdbC+4EFUM7Yip/lm5NcKhm+MkXty9k//pfs9GCsIRHpH16ILW7P6nAntFUs/d
	 M3/ktQAvXrDrkaEVWakag0jvQGp3T2ntcytBO9SKIcjdSji/nd3TxgUjWug/Al80w1
	 9mqRyqo7xBrLsSl6P1kvujGLBvA5ukLlSZVACKn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunshui Jiang <jiangyunshui@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.15 026/178] Input: cs40l50-vibra - fix potential NULL dereference in cs40l50_upload_owt()
Date: Tue,  8 Jul 2025 18:21:03 +0200
Message-ID: <20250708162237.233235748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunshui Jiang <jiangyunshui@kylinos.cn>

commit 4cf65845fdd09d711fc7546d60c9abe010956922 upstream.

The cs40l50_upload_owt() function allocates memory via kmalloc()
without checking for allocation failure, which could lead to a
NULL pointer dereference.

Return -ENOMEM in case allocation fails.

Signed-off-by: Yunshui Jiang <jiangyunshui@kylinos.cn>
Fixes: c38fe1bb5d21 ("Input: cs40l50 - Add support for the CS40L50 haptic driver")
Link: https://lore.kernel.org/r/20250704024010.2353841-1-jiangyunshui@kylinos.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/cs40l50-vibra.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/cs40l50-vibra.c
+++ b/drivers/input/misc/cs40l50-vibra.c
@@ -238,6 +238,8 @@ static int cs40l50_upload_owt(struct cs4
 	header.data_words = len / sizeof(u32);
 
 	new_owt_effect_data = kmalloc(sizeof(header) + len, GFP_KERNEL);
+	if (!new_owt_effect_data)
+		return -ENOMEM;
 
 	memcpy(new_owt_effect_data, &header, sizeof(header));
 	memcpy(new_owt_effect_data + sizeof(header), work_data->custom_data, len);


