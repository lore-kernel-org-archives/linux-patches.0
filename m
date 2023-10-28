Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4441401B
	for <patches@lists.linux.dev>; Sat, 28 Oct 2023 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jsperbeck.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U92AD9fw"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5af592fed43so19803467b3.2
        for <patches@lists.linux.dev>; Sat, 28 Oct 2023 11:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698518495; x=1699123295; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LT/obDBJABfb8QCqKTqEEdFn+fX3d4iF5BqppBNxXsU=;
        b=U92AD9fw/RfuYlMMeuGxZ1nbKTPET3mmu8BTSMxGyECo6kjz25vNQc1tJEACXQ00gT
         26e1j01Xig3QimCtFheN3jdLYRUUKY8Wa1CAdzBzEDLES1YFPHnMbmWOhjJ/pA4GZflt
         3MGQvL+BsIgX7g9Hi0x5m7z3xdugjeX5TGJaMkyGqHeZuDTby7EmXB9FumHA8Z2W0mTh
         roH83Wt2QKg8PNYo8RmVgP+778ynZ2yBjNmrciA7mN7bBkn04mhrJvTJ3dacXuPqJo12
         5LFYMLW3uPZLEXtRFmVCohuIh6GzMs2GzhVR/PMrogppTz8kPb3oYVQAUeJfAC2RFzjo
         e+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698518495; x=1699123295;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LT/obDBJABfb8QCqKTqEEdFn+fX3d4iF5BqppBNxXsU=;
        b=XMP06qH+pCTsoxyclFJRyKQk2QDSsLAZMgYuKd5tCekmitZoGQfNq3BYhS1hfA+3l7
         2vDQibm40CHkFtH+EyhQpXRZKRzO2d0VALL4DqoTLhFg7wyHDqGrSM9n00m4LUV3IBlz
         V4cwkVAHyalA7Jia6LOSGZ1wWYaKWnUTeV3HezUsw63plEexWpR/wXioPXC6mBLD2KtC
         PsPHfxz3x7ghyNwTf+v5lEs5VmsNDBKmETb8UpzjtsecuCsMtHB2+d/P9DN98NaCV5OT
         W8UxmhL6f2TCts15cSbSWcHXcii23wNnhwzLAZdOjDVfPog8u2RccwxC1in8wc5GzVwY
         Dfzw==
X-Gm-Message-State: AOJu0Yx+S6qOGP/WxZQaba7FF6rypw+DRvP0KtXxM+6jh5D/tFW2I2Iq
	d99/xORqMLtqXG9J1gixTa9TEMB+iAvu2TU=
X-Google-Smtp-Source: AGHT+IEWcYRt5CfYLxiiSv7LopaNWnrosDwtfmpOMt7IrDJPoCJywxVs2ewKYzO/4eNde4EHQG+2mTTUCRrvH6U=
X-Received: from jsperbeck7.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:26dc])
 (user=jsperbeck job=sendgmr) by 2002:a81:6c49:0:b0:5a7:ba09:44b6 with SMTP id
 h70-20020a816c49000000b005a7ba0944b6mr124674ywc.0.1698518494827; Sat, 28 Oct
 2023 11:41:34 -0700 (PDT)
Date: Sat, 28 Oct 2023 18:41:31 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231028184131.2103810-1-jsperbeck@google.com>
Subject: [PATCH v2] objtool/x86: add missing embedded_insn check
From: John Sperbeck <jsperbeck@google.com>
To: gregkh@linuxfoundation.org
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, 
	peterz@infradead.org, stable@vger.kernel.org, jsperbeck@google.com
Content-Type: text/plain; charset="UTF-8"

When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
was backported to some stable branches, the check for dest->embedded_insn
in is_special_call() was missed.  The result is that the warning it
was intended to suppress still appears.  For example on 6.1 (on kernels
before 6.1, the '-s' argument would instead be 'check'):

$ tools/objtool/objtool -s arch/x86/lib/retpoline.o
arch/x86/lib/retpoline.o: warning: objtool: srso_untrain_ret+0xd:
    call without frame pointer save/setup

With this patch, the warning is correctly suppressed, and the
kernel still passes the normal Google kernel developer tests.

Signed-off-by: John Sperbeck <jsperbeck@google.com>
---

I think 6.1.y, 5.15.y, and 5.10.y are the LTS branches missing the
bit of code that this patch re-adds.

Changes from v1 to v2:
* include more context in the commit message.


 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f8008ab31eef..cb363b507a32 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2478,7 +2478,7 @@ static bool is_special_call(struct instruction *insn)
 		if (!dest)
 			return false;
 
-		if (dest->fentry)
+		if (dest->fentry || dest->embedded_insn)
 			return true;
 	}
 
-- 
2.42.0.820.g83a721a137-goog

