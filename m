Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620205;
	b=eq4Q+A7wiFH0yy7J/2FT92w75DCMj1pLMz9SuklEPTrwh+59p8DWdUY1LHmOYLUMwall
	 RxeawXYJhZmtEOfxS5RF24q070019DWIkkcE7dUNpI9xj/GY5xO41XEfcxHCLQp9EFO3q
	 ulD9I58UPyTfh0tQ56n0wS2DyM4zY3Aa/uqWEApbL3omT+4hJQXc3ptIZvIWM71jQAHoL
	 0t5x2NOM0be7CTx8VWEA4DHga7H4oWDlgS4Iv6xzQY1p9niklUIcf8Z9RGK+S+HhmH/u5
	 a9abJppC+4Q2skTKf+uH20b6RA+hvuUPkqsKxt/tCNRAQ5/WQ7IwowpjhUFwHnNKNXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1tVI/rI/hMWV7oLgtGguEt4cY3JvVCoXdTxY0n3h7j4=;
	b=vAihqigD2gS2yUsKQ/XWWvVbpJmevR+PyqF8IIHAJv52BMasXPJPB3iXlC9wdsNbNpeC
	 rAvFZKKjAgftriAVNaP17Kvbd0t/NUYA6hxCr3TM1vU4V6JVYhZKro5Sci2WZbglKgxFH
	 hqCODX499ZG05f1nCmmSLEytuEBoLVwgjmNIjUxjVUISXXybH7JH59WHdMBZj4zA+nimE
	 oBlUOnZ/zSnUEHwuMaB35/yltYB7DHNBQYSRYj4e1YJHUJyrWDf+wiUSfKa8wgyB5AQer
	 cfp6c+LJLnSyzBis2n/CPYoooNwCWNXE01uXZyrBKD0zzybssIb69UvSTM7U8f/Q5hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U7d/dRPn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075FF606A326;
	Wed, 25 Nov 2026 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7d/dRPn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ADA1F000D1;
	Wed, 25 Nov 2026 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620204;
	bh=1tVI/rI/hMWV7oLgtGguEt4cY3JvVCoXdTxY0n3h7j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7d/dRPnxJpGE9QMkJ0FKkRpf/AUAKnlaMSCR9b/h3cx9o4t4Jk65nUXT3lZUg5Pp
	 qetDZ9jXrXpdIPFiJJa3fWhEn+U4s3GxmfZ75lT48v2WHLe5A1r/sCkQm0DIO31ccB
	 sZ4XdIxZ1JUzqleb97twd5da2kdG55GDRUE/f25E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0788/1005] tracing/probes: Fix missing BTF kind checks in char pointer/array helpers
Date: Wed, 25 Nov 2026 15:35:26 +0100
Message-ID: <20261125143840.199160967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c1e2c63e65421068566db3dde44dfd4fe7adb46d upstream.

In struct btf_type, the type ID and byte size share a union, and only
BTF_KIND_INT types are followed by a 32-bit integer encoding word.
Because btf_type_is_char_ptr() and btf_type_is_char_array() do not
verify that the outer type is BTF_KIND_PTR or that the resolved element
type is a non-NULL BTF_KIND_INT before inspecting it, non-pointer BTF
types can have their byte size misinterpreted as a BTF type ID, and
arrays of non-integer types read out-of-bounds or misinterpret trailing
BTF metadata as BTF_INT_* encoding bits.

Validate the BTF type kinds and NULL pointers before reading inner type
metadata in both helpers.

Link: https://lore.kernel.org/all/179455851632.403392.258264246782960594.stgit@devnote2/

Fixes: 27973e5c64b9 ("tracing/probes: Add string type check with BTF")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -411,6 +411,9 @@ static bool btf_type_is_char_ptr(struct
 	const struct btf_type *real_type;
 	u32 intdata;
 
+	if (BTF_INFO_KIND(type->info) != BTF_KIND_PTR)
+		return false;
+
 	real_type = btf_type_skip_modifiers(btf, type->type, NULL);
 	if (!real_type)
 		return false;
@@ -435,6 +438,11 @@ static bool btf_type_is_char_array(struc
 	array = (const struct btf_array *)(type + 1);
 
 	real_type = btf_type_skip_modifiers(btf, array->type, NULL);
+	if (!real_type)
+		return false;
+
+	if (BTF_INFO_KIND(real_type->info) != BTF_KIND_INT)
+		return false;
 
 	intdata = btf_type_int(real_type);
 	return !(BTF_INT_ENCODING(intdata) & BTF_INT_SIGNED)


