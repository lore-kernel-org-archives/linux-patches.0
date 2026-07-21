Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E03E3E49F5;
	Tue, 21 Jul 2026 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654911; cv=none; b=FjFJbt632vLUGFkEdf8DcaUuuQ7Y9CQD7hDTWyUxbUBVBQuQSnk8eDpi6eoeNHJqbTzgwqUo5jY71r8HSc0MkDJ8rZdmq6VSgAQl1mTelr3nQj+GQlXuSIwHzURwZqlhDBt/YO3uQwcpefklb8P/hpwk79AMb7pH/V32RLnBcz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654911; c=relaxed/simple;
	bh=HUBOsuAw9qElcMU9diAaTwIq/gd0FLwMcjzM0rdyp9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2ojGLn+lfzMeplDb/kzSr1BYquynPJkTd0F4Wl2wGp7Vcodj3agT8tWOW+4Tv5KyO7wdQ8U0PvThs+SNXbTBRe0vZf7l/hCzcOky7LyLkjdSP4DWV/afNUtdyeYec8ULsL8+ZjWETHdnZebp+h8tbwfeQiuX/6nhb7FAXsM4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVNHIiUr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVNHIiUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930801F000E9;
	Tue, 21 Jul 2026 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654910;
	bh=VP4ta1iU3TThkC2WlIOd8fk8lgHRC0Z2vtysZ6T97UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVNHIiUrc7zPHFPf8aNv63iYsHBjpgxsxsdhSJtCt2wbL4M3iafOYYDUVRva4xRWF
	 sFhEqbMMywbYu/m7Dkty9NpSEFf/FI0WK8lhwkyUMUnKD43fvTwvtFHLpkH25CVss5
	 be0gySfb8rsHhyBTqHDe5b1F9VJseQvlVTEn288E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1847/2077] dm-ioctl: fix a possible overflow in list_version_get_info
Date: Tue, 21 Jul 2026 17:25:20 +0200
Message-ID: <20260721152636.304211329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 76c6f845dc0c614304a6e6ee619b552f97cf24b3 upstream.

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -698,7 +698,7 @@ static void list_version_get_info(struct
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}


