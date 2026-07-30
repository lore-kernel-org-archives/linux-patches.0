Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9863E443E44;
	Thu, 30 Jul 2026 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427695; cv=none; b=LeoijVnHm66cd5zzT5pMEeFRwE4PgV3H7dlY6iH49jWfFC2icIEux5TD95aMFecnTsfHLlEjyJ5WVPhTw3KlgXdRa0fK7NXQYUfUzUVk7iJ83SmUeHhjEfVCVerNehV79XXAa1xZHAySLO8MqvPOKTqjdjZNWJl/qafZVTSexjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427695; c=relaxed/simple;
	bh=TMerXJrYisuZ/HpNNVzlNFa8PW2Y3zXSWATC6QiTjFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jocSh4muyQXfXMsGl6qN9PobPfHOTBIKl/+rXP2m0FZwGx2yjOn34txo161rLUJIcuQHLZ5xZFD1I+19juuC4M4Ib7GJl6WVNLGyeai54VIXcpvjvCKqhYGyN25faioTmJwnp8SrhBw/O5JOuuL2zdt4fpWzqPEdH0p0J5brtfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ03C9bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ03C9bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867951F000E9;
	Thu, 30 Jul 2026 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427693;
	bh=THvI1A2E7RSjnlod7I0SZ8dt1EHFr5J/gbBlJwmqsu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQ03C9bxMxNAIqLbaUOrZSixdgJCUI/zqZZgWh5rTmReoUO0swbLFU1ZAwhCgrejx
	 QPWWZSlkvEhCWJw6hDLAAS8uS1E4vSncXhypAeT4LxFOWnQVeh/PWB+tmNOLAY8vcy
	 uG5WgGx3Fbfqp/6yZKaP0e9mY8AIj+mB8r9sXbc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 6.6 259/484] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Thu, 30 Jul 2026 16:12:36 +0200
Message-ID: <20260730141429.117223311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit d5b50055338e131a1a99f923ebb0361974a00f36 upstream.

tegra_get_format_fourcc_by_idx() returns a u32 but uses -EINVAL to
signal an out-of-bounds index. This results in a large unsigned
value being returned, which may be interpreted as a valid fourcc.

Returning 0 is not a valid fourcc either. This condition should
never happen, so use WARN_ON_ONCE() to catch unexpected out-of-bounds
access and return a valid fallback format instead.

Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: 3d8a97eabef0 ("media: tegra-video: Add Tegra210 Video input driver")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -80,8 +80,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


