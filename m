Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD91A76A5;
	Tue, 30 Jul 2024 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360684; cv=none; b=bIS+XtzFlsAonaXFOgKfJsj760UiXZhwXjjOqkjUj5PsKoVX7SuLjUzW2ggcuiaZdUGLGgN+Vp1dX0BjomQZJ2GCJRda/ng0z6PQVbL+vrfEXNxVCIjSb5xYR9J6bqvtLVDcdyanqvoceDG0LhlO5aFUnpRrkew9epz4iu6NWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360684; c=relaxed/simple;
	bh=ZR9sCRDai23/lp3PESr7Vsfxwap6f6Vn2zmu9XI9Y2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT+YseV4F2Sw3wnppBzUVv5vF0f4q0q/VKcEiRXHCVptFyy2NI8YpwYCJ3OAq7hhN77dei1mXakRGJNpnIi2ydfwW2UYsoGZcDabZxivTA2PUAWJ2bOoibL7rE3qqtDuKkrADzO2+mruzxgGYNYiBzV5mjlMc7BxBLobK8mSGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njI/k1HD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njI/k1HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D4FC32782;
	Tue, 30 Jul 2024 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360684;
	bh=ZR9sCRDai23/lp3PESr7Vsfxwap6f6Vn2zmu9XI9Y2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njI/k1HDlOFTHQ5nf/Y8ktu+UbU/5vRLA+P5EM4B9L6I5V3eqRe3J7L2C6520vS4i
	 S8/IynTNXc7/SYH7OCENguJMjUlOSyWtrfq36ObpjZXt5tgnSt+q9IZxvxWnxSX3Bq
	 0w+Fh24p50bru3T2F8R6uALgawirp7Vz9JLkniAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 776/809] lirc: rc_dev_get_from_fd(): fix file leak
Date: Tue, 30 Jul 2024 17:50:52 +0200
Message-ID: <20240730151755.617996184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bba1f6758a9ec90c1adac5dcf78f8a15f1bad65b ]

missing fdput() on a failure exit

Fixes: 6a9d552483d50 "media: rc: bpf attach/detach requires write permission" # v6.9
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/lirc_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 52aea41677183..717c441b4a865 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -828,8 +828,10 @@ struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (write && !(f.file->f_mode & FMODE_WRITE))
+	if (write && !(f.file->f_mode & FMODE_WRITE)) {
+		fdput(f);
 		return ERR_PTR(-EPERM);
+	}
 
 	fh = f.file->private_data;
 	dev = fh->rc;
-- 
2.43.0



