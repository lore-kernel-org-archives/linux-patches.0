Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E3D26A09F;
	Tue,  8 Apr 2025 11:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110124; cv=none; b=QSbFojZuQHOgNEKEoLRFjYrSjGkkqk4GBqDrCOaYk4SBVbNSgXbrpfEhhyiAvpwrpqg/64up0+6YpEIg6qGSpNFy+x9GtpIuP4v1O0N4iP+E3gXzKn0Db7NhaEYdZWet9GVCR3MRB3ccI3Z5exZjTaDGZzKoz/g4cKc2CpnjY7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110124; c=relaxed/simple;
	bh=+P881TMxrnUKMVfqSlx4MsFBf3Shr8k4PLmIU4gzPgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8rNx8xGwPcgbSOzI7M9Ev8NMW7hgsMYqbKlX2451s0ojFdS2w3NnaadVF/BUF1DtaWNGREy5VO8mVl2ckDw6go+qxrOxecH2VGepkh+d4+umdahq8fC0yL17byXBb/Lz6GXU5JuqSkY3G0j/UclzG/mBmSoFGC5/sspipVyhTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+HpqEav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+HpqEav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463AEC4CEE5;
	Tue,  8 Apr 2025 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110123;
	bh=+P881TMxrnUKMVfqSlx4MsFBf3Shr8k4PLmIU4gzPgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+HpqEavtklmmAf645lf534wcgV+R8FDEapiQC3IUBSEzeJ/drawwNfIiKh8bEqJs
	 Zsoz2IMCERl9KyMbq9eQN0bJ9seVSrvU9+ceHAQXoIrySWdymumlY3z9K3ANWTdYh2
	 LDfQCHmzEV2mLn/uoOmnDv/tDnJfET9yJT3KNLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/227] ring-buffer: Fix bytes_dropped calculation issue
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104825.625587214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit c73f0b69648501978e8b3e8fa7eef7f4197d0481 ]

The calculation of bytes-dropped and bytes_dropped_nested is reversed.
Although it does not affect the final calculation of total_dropped,
it should still be modified.

Link: https://lore.kernel.org/20250223070106.6781-1-yangfeng59949@163.com
Fixes: 6c43e554a2a5 ("ring-buffer: Add ring buffer startup selftest")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9a2c8727b033d..225dbe4a56413 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5768,9 +5768,9 @@ static __init int rb_write_something(struct rb_test_data *data, bool nested)
 		/* Ignore dropped events before test starts. */
 		if (started) {
 			if (nested)
-				data->bytes_dropped += len;
-			else
 				data->bytes_dropped_nested += len;
+			else
+				data->bytes_dropped += len;
 		}
 		return len;
 	}
-- 
2.39.5



