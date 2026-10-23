Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774071;
	b=TqgvHof98nlv46N9WsvUZCQt/bnnWfv1pxQPsU2NZPLXisvsAUzEjKCId+XzI1Qqct6D
	 CPfDeJ5rITObK6K5xAIknr1LrTE4aNUH7A7Jg393ILdAFXTsi/ExBm4ITsItnowTfRkkp
	 nr92S/Cfu0NBUx9A7R+dJoc5XQ4X2TykH/k/R301AStbR2+gp6R1Li8iA4KEOG2NKBwZy
	 etUZGOnwM4ELYiKEz9qr0w1w94G9aweXvEwCwF8arNp8d+WVXw4/Vj4VJdSy3BmcoyAyU
	 SGouLEuAdheEXNBrv0vXtstkdiWdxjsGU9I6mGS2xs/Ehu/bvf1jB+PdeShUm8B6InA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q0N7TlE+MVhlxSQe3v0F8czSaJEBBFMpv2mWCXrRxDY=;
	b=hG8oOU1Iz2A23DlhnfbHF3FArRKBLgl0tFGKXEAIgVreHttox87F5x5BC5qlgMAOQ4pU
	 cZ7T+bSTo60awZm1E4YoTMsZLYSTfxW2LhdqRXQt+SYzTe0QAwnR07nh50WoeYaYyDlX2
	 pGwjXqqBgjQusMcewZNQ/xxBXUQLmB9RoGSL0FDC+eb23nkDQlSUQhT+dXOdDVeMzyuDy
	 3HvnFQr/FMkOnY7b8PZO0nvoD+5xMJpvknEdSdc8Tv6Kdp+Amx4sKvVqwi6qlb3jXBADf
	 k2KbGSzploLAuHipSGA723JKFar8EwWe7S62EOS2cbuZoP57yIsK2iArtJuqIhndbGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=estHrNC7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E340606A31E;
	Fri, 23 Oct 2026 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=estHrNC7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC48B1F01825;
	Fri, 23 Oct 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774071;
	bh=Q0N7TlE+MVhlxSQe3v0F8czSaJEBBFMpv2mWCXrRxDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=estHrNC7eTM48ZtE+j7clUXgPLtempaii+OvZtpDtOgOEtdV8EEna9k22u5IuKerq
	 G3/NzoIyRYDePZelo0CBTuI2T97NzkLGu+fubs5MOeI7M1z0T6rNd+cV5zBHAOyzPG
	 OL/G0Vgn4mL+y4fOzPJjojFzRl2Eo6I5t+emgYDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 112/193] tracing: Take trace_types_lock when dropping the buffer_meta reference
Date: Fri, 23 Oct 2026 18:36:29 +0200
Message-ID: <20261023163716.857121087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 2afe7575fb24b9d0476ae4a3a9862f7997216aa4 upstream.

tracing_buffer_meta_open() drops the trace_array reference with
__trace_array_put() when ring_buffer_meta_seq_init() fails, without
holding trace_types_lock. Use trace_array_put() like every other open
error path.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914133506.4865-2-devnexen@gmail.com
Fixes: 950032ffcee7 ("ring-buffer: Add output of ring buffer meta page")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7127,7 +7127,7 @@ static int tracing_buffer_meta_open(stru
 
 	ret = ring_buffer_meta_seq_init(filp, tr->array_buffer.buffer, cpu);
 	if (ret < 0)
-		__trace_array_put(tr);
+		trace_array_put(tr);
 	return ret;
 }
 


