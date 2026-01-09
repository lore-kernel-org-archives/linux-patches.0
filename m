Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E535A943;
	Fri,  9 Jan 2026 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960954; cv=none; b=Z0b9XBCcULcX3owLXERlPzDB2Txv4RkPadfZCwNcL5YMrXAIop8TWMSN1flq++8r28a7j/xdWPKTzGFqhulQEYuUY7K5MeqKqtDIEg1Ot7+Nszh/ST8jBzND5KG9M+zkoLzsMz19Evq1GmNK74aabMxdVefKCrz4cYTCMmAVB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960954; c=relaxed/simple;
	bh=48vs9ErYCTx6eeYqhekbZpApXkLIAfqcrSmUjz9vZOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p53SB5gEbjv/ok1atzw8Hx9tq4XlgIIJNRkmj/U5/igzThT4EtLWetj7We3J8gUclbUoNqUqeTZ1TuIxlKch9EGPn681dRB2ubwQLqA9M+ht4gmzv72sFzO2s4TGIlLiRKEzrsq9MKsnmXWf+2jTV46KG7i/TPo+TEDosQsejXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0asJJfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0asJJfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAEEC4CEF1;
	Fri,  9 Jan 2026 12:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960953;
	bh=48vs9ErYCTx6eeYqhekbZpApXkLIAfqcrSmUjz9vZOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0asJJfs1MAnPSjZKWg9oTKfGaC/r6zNMAdHX8mGofHqY7GTd2M7BWJNw97OwOsVp
	 KVJISQvHbDuiOlT85ccwGjOHw/WwPpilWJNptF5O2KOgLdMApv1Tl22CspHsXMykIE
	 tJ8OgZxqcje7xpMcEb8YbfUoG0etrBfzdmzKoMYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 584/737] media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()
Date: Fri,  9 Jan 2026 12:42:03 +0100
Message-ID: <20260109112155.969239601@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

commit d2bceb2e20e783d57e739c71e4e50b4b9f4a3953 upstream.

It's possible for max1 to remain -1 if msp_read() always fail. This
variable is further used as index for accessing arrays.

Fix that by checking max1 prior to array accesses.

It seems that restart is the preferable action in case of out-of-bounds
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8a4b275f9c19 ("V4L/DVB (3427): audmode and rxsubchans fixes (VIDIOC_G/S_TUNER)")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/msp3400-kthreads.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -596,6 +596,8 @@ restart:
 				"carrier2 val: %5d / %s\n", val, cd[i].name);
 		}
 
+		if (max1 < 0 || max1 > 3)
+			goto restart;
 		/* program the msp3400 according to the results */
 		state->main = msp3400c_carrier_detect_main[max1].cdo;
 		switch (max1) {


