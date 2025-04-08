Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A0F26F478;
	Tue,  8 Apr 2025 12:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117080; cv=none; b=tZF6Rssmi1COluZaSHBFqj15pR/Xg2tP0MVJvpixstQRUjytcg8jIyNVY8bVeAYGuyZ/+QaDNk1v0lAbbnEVrxmCzlW8d37oLFlqaMhi68WhqxOWaHXB1ffExYLRYNl0jxCH98KC/h7GiOoRw2NCs/djUugHbuRH8fSWAUlm1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117080; c=relaxed/simple;
	bh=959scZ3c6HxBKwp1CAJsjJAm1Edc9E2o7+xyQGNLgzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nb2HvstMKUuFTclBMhvJbsiTto+Ir1XUv+eKb7ajlIwp30F9PFdS3jB9NWPpg/Z0f2mBPwWGjQsiBH8JZTTOqYtHASTkZPpZVAhu9rK/5ND4yy+r7kkLNsOZN2QGiaefgHuHlXK2GgMDB/sgebdvrcKkiilIBy01Xn6q1vcwGbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh8YbiJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh8YbiJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9428BC4CEE5;
	Tue,  8 Apr 2025 12:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117079;
	bh=959scZ3c6HxBKwp1CAJsjJAm1Edc9E2o7+xyQGNLgzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh8YbiJVX1Au501CxGJHiI0AV7LxHhRp9priBQ9JMUs3Eay4Z0DH7SvbA1U0QAP6h
	 cVyIKGIxr1cwXRj/GGZ/1aktBGZsX7jzqZ9oD6IXiDh9tiLVtDHYKbTnh7WCrY1XYq
	 q1L7H65aOee9cp0ZxlQNimmBNcgMMq1I/edVmDKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.12 376/423] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:51:42 +0200
Message-ID: <20250408104854.629908596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

commit 4279e72cab31dd3eb8c89591eb9d2affa90ab6aa upstream.

The function call “dmaengine_unmap_put(unmap)” was used in an if branch.
The same call was immediately triggered by a subsequent goto statement.
Thus avoid such a call repetition.

This issue was detected by using the Coccinelle software.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/test/ntb_perf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -839,10 +839,8 @@ static int perf_copy_chunk(struct perf_t
 	dma_set_unmap(tx, unmap);
 
 	ret = dma_submit_error(dmaengine_submit(tx));
-	if (ret) {
-		dmaengine_unmap_put(unmap);
+	if (ret)
 		goto err_free_resource;
-	}
 
 	dmaengine_unmap_put(unmap);
 


