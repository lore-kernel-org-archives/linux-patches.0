Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F0D43F0BE;
	Thu, 30 Jul 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422469; cv=none; b=j8mUzHdmw6hYNv6VpPMx5olSV6h4Vw4qg+hWSLFTsyjhHVzkK4x2Goqp12nXmli3wFojrmI4Y7g+VtRztDbG6suwhN3DuOeF6JlIh9JRVIj4HLRS0OH4car2HMJjIR2Eu18y1rVttWIOFZvZltmQSY9q9pmAvN38GS9+O2huV5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422469; c=relaxed/simple;
	bh=uoIfeg0MvFn9JqrOiwnOw0X1mv5LlQtuv2RFtNLCBJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSgocDT6T7czxh7rN7foKNdMh77VaStUvP7Yht7ul5jsnPqZ8axjbiqaJE2JvZcuw/fORpAxLKmv7+xcWUoNKpFeOh8KE5AW9MbHXa1HmaIs/s54jKQw7ns7C4+uJylzE3TfZifPcg46DTRrUhFDpFlFhGC52m6LmZaOpntbYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDoKj1Dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDoKj1Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8AA1F000E9;
	Thu, 30 Jul 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422468;
	bh=oa4aEcZ4YVDAM5q6Flc3/lMwFVzPWqAynp6o9dXseMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDoKj1DrMrPNDaW//9S8g/attPNJaMiot1U0GbF0PBZ4pVnukN/FHq/vPBQlBMW4c
	 8kGblyJLKjWaDNtgZDwR88JoEhJV5mMtEm52r5RNp9xo55rcWwvTYdJuL25m9S4tpH
	 SEy+64LPInG1GWu8N1Cr1ump993d2fgjUj/HuhUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 7.1 448/744] drm/panthor: return error on truncated firmware
Date: Thu, 30 Jul 2026 16:12:01 +0200
Message-ID: <20260730141453.818640696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 4a2c8cbe9bcba170706fdf08b1c84b6cbcf5b044 upstream.

panthor_fw_load() detects truncated firmware images, but jumps to the
common cleanup path without setting ret. If no previous error was recorded,
the function can return 0 and treat the invalid firmware as successfully
loaded.

Set ret to -EINVAL before leaving the truncated-image path.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260714163056.22329-1-osama.abdelkader@gmail.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -824,6 +824,7 @@ static int panthor_fw_load(struct pantho
 	}
 
 	if (hdr.size > iter.size) {
+		ret = -EINVAL;
 		drm_err(&ptdev->base, "Firmware image is truncated\n");
 		goto out;
 	}


