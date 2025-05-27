Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1394578F32;
	Tue, 27 May 2025 17:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365236; cv=none; b=IebEBCGzBbDvjOoqFdj4UYRz7acQB1l3Igic5FxfkC+0N16NkcUEXPdoMEmdv9xzbg3mtYex5UcGLJtBqzkpEoT7JORNRVKYDVSZ2VKdT3g2H728D6PiVlT6eUrFTu7RT5gzkURTkBsXda/ypIL5qZ+KpKJEuJ7RLBKAylQqOjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365236; c=relaxed/simple;
	bh=MHHQ210jv4tgJ3x7SHrUFtj8hZJjP9oKQ0wu/hzNwLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+YO2yAsnQu4pONqR+gWVfSzGyiNuyzzy2ow1MglJtSwAkdDFV0TzfiBMx/IKm9TP953AK6nZmGiP5ckS8O4nx8ju+QU+wixQudDi/xM7CZjAJDghhU++m4t8t9W6ZaQJcXSc9XvbCpO/ctNVgpGVsE+PRIqJIlfktbtgRn9T14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo/F/gPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo/F/gPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAB9C4CEE9;
	Tue, 27 May 2025 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365236;
	bh=MHHQ210jv4tgJ3x7SHrUFtj8hZJjP9oKQ0wu/hzNwLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo/F/gPrFXGfaKTvHKbwZPVgc8SzpX/fDHlEpQfQrcKlq3S6aW2uQBLPQj0AUGTo4
	 z0Jj9MBCRU3xHVzvJIJ1DSRvG/NpWuRUMU9AH6iq5JkIKoeihmGn5bF/hq/pwHmMGu
	 Ki8QPyqWCPJLjpoCGW7uuEluqxTeC+BQH+7Kqv08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/626] drm/xe/oa: Ensure that polled read returns latest data
Date: Tue, 27 May 2025 18:23:22 +0200
Message-ID: <20250527162457.589419816@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 98c9d27ab30aa9c6451d3a34e6e297171f273e51 ]

In polled mode, user calls poll() for read data to be available before
performing a read(). In the duration between these 2 calls, there may be
new data available in the OA buffer. To ensure user reads all available
data, check for latest data in the OA buffer in polled read.

Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250212010255.1423343-1-umesh.nerlige.ramappa@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 448766033690c..d306ed0a04434 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -535,6 +535,7 @@ static ssize_t xe_oa_read(struct file *file, char __user *buf,
 			mutex_unlock(&stream->stream_lock);
 		} while (!offset && !ret);
 	} else {
+		xe_oa_buffer_check_unlocked(stream);
 		mutex_lock(&stream->stream_lock);
 		ret = __xe_oa_read(stream, buf, count, &offset);
 		mutex_unlock(&stream->stream_lock);
-- 
2.39.5



